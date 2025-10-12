namespace AmuseYou.RentalOperations.Test;

using AmuseYou.BookingCore;
using AmuseYou.RentalOperations;

codeunit 50301 "Booking Mgt Tests"
{
    Subtype = Test;

    [Test]
    procedure TestCreateBookingCalculatesAmount()
    var
        Equipment: Record Equipment;
        Booking: Record Booking;
        BookingMgt: Codeunit BookingMgt;
    begin
        // [GIVEN] Equipment with daily rate
        CreateTestEquipment(Equipment, 'CALC001', 150);

        // [GIVEN] A new booking for 3 days
        Booking.Init();
        Booking."Booking No." := 'BOOK001';
        Booking."Equipment No." := 'CALC001';
        Booking."Customer Name" := 'Jane Smith';
        Booking."Start Date" := Today();
        Booking."End Date" := Today() + 2;

        // [WHEN] Booking is created
        BookingMgt.CreateBooking(Booking);

        // [THEN] Total amount is calculated correctly (3 days * 150)
        Booking.Get('BOOK001');
        Assert.AreEqual(450, Booking."Total Amount", 'Total amount should be 450 for 3 days at 150 per day');
    end;

    [Test]
    procedure TestCancelBooking()
    var
        Booking: Record Booking;
        BookingMgt: Codeunit BookingMgt;
        Success: Boolean;
    begin
        // [GIVEN] A confirmed booking
        CreateTestBooking(Booking, 'CANCEL001', BookingStatus::Confirmed);

        // [WHEN] Booking is cancelled
        Success := BookingMgt.CancelBooking('CANCEL001');

        // [THEN] Booking status is cancelled
        Assert.IsTrue(Success, 'Cancel operation should succeed');
        Booking.Get('CANCEL001');
        Assert.AreEqual(BookingStatus::Cancelled, Booking.Status, 'Booking should be cancelled');
    end;

    local procedure CreateTestEquipment(var Equipment: Record Equipment; EquipmentNo: Code[20]; DailyRate: Decimal)
    begin
        Equipment.Init();
        Equipment."No." := EquipmentNo;
        Equipment.Description := 'Test Equipment';
        Equipment."Equipment Type" := EquipmentType::BounceUnit;
        Equipment."Daily Rental Rate" := DailyRate;
        Equipment.Insert();
    end;

    local procedure CreateTestBooking(var Booking: Record Booking; BookingNo: Code[20]; Status: Enum BookingStatus)
    begin
        Booking.Init();
        Booking."Booking No." := BookingNo;
        Booking."Equipment No." := 'TEST001';
        Booking."Customer Name" := 'Test Customer';
        Booking."Start Date" := Today();
        Booking."End Date" := Today() + 1;
        Booking.Status := Status;
        Booking.Insert();
    end;
}
