namespace AmuseYou.RentalOperations.Test;

using AmuseYou.BookingCore;
using AmuseYou.RentalOperations;

codeunit 50300 "Availability Tests"
{
    Subtype = Test;

    [Test]
    procedure TestEquipmentAvailableWhenNoBookings()
    var
        Equipment: Record Equipment;
        AvailabilityMgt: Codeunit AvailabilityMgt;
        IsAvailable: Boolean;
    begin
        // [GIVEN] Equipment with no bookings
        CreateTestEquipment(Equipment, 'AVAIL001');

        // [WHEN] Checking availability
        IsAvailable := AvailabilityMgt.IsEquipmentAvailable('AVAIL001', Today(), Today() + 2);

        // [THEN] Equipment is available
        Assert.IsTrue(IsAvailable, 'Equipment should be available when no bookings exist');
    end;

    [Test]
    procedure TestEquipmentNotAvailableWhenBooked()
    var
        Equipment: Record Equipment;
        Booking: Record Booking;
        AvailabilityMgt: Codeunit AvailabilityMgt;
        IsAvailable: Boolean;
    begin
        // [GIVEN] Equipment with confirmed booking
        CreateTestEquipment(Equipment, 'AVAIL002');
        CreateTestBooking(Booking, 'BOOK001', 'AVAIL002', Today(), Today() + 2, BookingStatus::Confirmed);

        // [WHEN] Checking availability for overlapping dates
        IsAvailable := AvailabilityMgt.IsEquipmentAvailable('AVAIL002', Today() + 1, Today() + 3);

        // [THEN] Equipment is not available
        Assert.IsFalse(IsAvailable, 'Equipment should not be available when already booked');
    end;

    [Test]
    procedure TestGetAvailableEquipmentByType()
    var
        Equipment1, Equipment2, Equipment3: Record Equipment;
        TempAvailableEquipment: Record Equipment temporary;
        AvailabilityMgt: Codeunit AvailabilityMgt;
    begin
        // [GIVEN] Multiple bounce units, one booked
        CreateTestEquipment(Equipment1, 'BOUNCE001');
        CreateTestEquipment(Equipment2, 'BOUNCE002');
        CreateTestEquipment(Equipment3, 'BOUNCE003');

        CreateTestBooking(Equipment1, 'BOOK001', 'BOUNCE001', Today(), Today() + 2, BookingStatus::Confirmed);

        // [WHEN] Getting available bounce units
        AvailabilityMgt.GetAvailableEquipment(EquipmentType::BounceUnit, Today(), Today() + 2, TempAvailableEquipment);

        // [THEN] Only unbooked equipment is returned
        Assert.AreEqual(2, TempAvailableEquipment.Count(), 'Should return 2 available bounce units');
    end;

    local procedure CreateTestEquipment(var Equipment: Record Equipment; EquipmentNo: Code[20])
    begin
        Equipment.Init();
        Equipment."No." := EquipmentNo;
        Equipment.Description := 'Test Equipment';
        Equipment."Equipment Type" := EquipmentType::BounceUnit;
        Equipment."Daily Rental Rate" := 100;
        Equipment.Blocked := false;
        Equipment.Insert();
    end;

    local procedure CreateTestBooking(var Booking: Record Booking; BookingNo: Code[20]; EquipmentNo: Code[20]; StartDate: Date; EndDate: Date; Status: Enum BookingStatus)
    begin
        Booking.Init();
        Booking."Booking No." := BookingNo;
        Booking."Equipment No." := EquipmentNo;
        Booking."Customer Name" := 'Test Customer';
        Booking."Start Date" := StartDate;
        Booking."End Date" := EndDate;
        Booking.Status := Status;
        Booking.Insert();
    end;
}
