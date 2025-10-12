namespace AmuseYou.Integration.Test;

using AmuseYou.BookingCore;
using AmuseYou.RentalOperations;

codeunit 50400 "End-to-End Booking Tests"
{
    Subtype = Test;

    [Test]
    procedure TestCompleteBookingWorkflow()
    var
        Equipment: Record Equipment;
        Booking: Record Booking;
        BookingMgt: Codeunit BookingMgt;
        AvailabilityMgt: Codeunit AvailabilityMgt;
        IsAvailable: Boolean;
    begin
        // [SCENARIO] Complete booking lifecycle from creation to completion

        // [GIVEN] Available equipment
        CreateTestEquipment(Equipment, 'E2E001', EquipmentType::BounceUnit, 200);

        // [WHEN] Checking availability
        IsAvailable := AvailabilityMgt.IsEquipmentAvailable('E2E001', Today(), Today() + 3);
        Assert.IsTrue(IsAvailable, 'Equipment should be available');

        // [WHEN] Creating a booking
        Booking.Init();
        Booking."Booking No." := 'E2EBOOK001';
        Booking."Equipment No." := 'E2E001';
        Booking."Customer Name" := 'Integration Test Customer';
        Booking."Start Date" := Today();
        Booking."End Date" := Today() + 3;
        BookingMgt.CreateBooking(Booking);

        // [THEN] Booking is created with correct amount
        Booking.Get('E2EBOOK001');
        Assert.AreEqual(800, Booking."Total Amount", 'Amount should be calculated for 4 days');
        Assert.AreEqual(BookingStatus::Pending, Booking.Status, 'Initial status should be Pending');

        // [WHEN] Confirming the booking
        BookingMgt.UpdateBookingStatus('E2EBOOK001', BookingStatus::Confirmed);

        // [THEN] Booking is confirmed
        Booking.Get('E2EBOOK001');
        Assert.AreEqual(BookingStatus::Confirmed, Booking.Status, 'Status should be Confirmed');

        // [THEN] Equipment is no longer available for overlapping dates
        IsAvailable := AvailabilityMgt.IsEquipmentAvailable('E2E001', Today() + 1, Today() + 2);
        Assert.IsFalse(IsAvailable, 'Equipment should not be available during booked period');

        // [WHEN] Completing the booking
        BookingMgt.UpdateBookingStatus('E2EBOOK001', BookingStatus::Completed);

        // [THEN] Booking workflow is complete
        Booking.Get('E2EBOOK001');
        Assert.AreEqual(BookingStatus::Completed, Booking.Status, 'Final status should be Completed');
    end;

    [Test]
    procedure TestConcurrentBookingPrevention()
    var
        Equipment: Record Equipment;
        Booking1, Booking2: Record Booking;
        BookingMgt: Codeunit BookingMgt;
        ErrorOccurred: Boolean;
    begin
        // [SCENARIO] Prevent double-booking of equipment

        // [GIVEN] Available equipment
        CreateTestEquipment(Equipment, 'CONCURRENT001', EquipmentType::GoKartExperience, 300);

        // [GIVEN] First booking is confirmed
        Booking1.Init();
        Booking1."Booking No." := 'FIRST001';
        Booking1."Equipment No." := 'CONCURRENT001';
        Booking1."Customer Name" := 'First Customer';
        Booking1."Start Date" := Today();
        Booking1."End Date" := Today() + 5;
        BookingMgt.CreateBooking(Booking1);
        BookingMgt.UpdateBookingStatus('FIRST001', BookingStatus::Confirmed);

        // [WHEN] Attempting overlapping booking
        Booking2.Init();
        Booking2."Booking No." := 'SECOND001';
        Booking2."Equipment No." := 'CONCURRENT001';
        Booking2."Customer Name" := 'Second Customer';
        Booking2."Start Date" := Today() + 2;
        Booking2."End Date" := Today() + 7;

        ErrorOccurred := false;
        asserterror BookingMgt.CreateBooking(Booking2);
        if GetLastErrorText() <> '' then
            ErrorOccurred := true;

        // [THEN] Second booking is prevented
        Assert.IsTrue(ErrorOccurred, 'Overlapping booking should be prevented');
        Assert.IsFalse(Booking2.Get('SECOND001'), 'Second booking should not exist');
    end;

    local procedure CreateTestEquipment(var Equipment: Record Equipment; EquipmentNo: Code[20]; EquipmentType: Enum EquipmentType; DailyRate: Decimal)
    begin
        Equipment.Init();
        Equipment."No." := EquipmentNo;
        Equipment.Description := 'Integration Test Equipment';
        Equipment."Equipment Type" := EquipmentType;
        Equipment."Daily Rental Rate" := DailyRate;
        Equipment.Blocked := false;
        Equipment.Insert();
    end;
}
