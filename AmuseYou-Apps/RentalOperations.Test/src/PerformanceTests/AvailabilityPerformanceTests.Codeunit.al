namespace AmuseYou.RentalOperations.Test;

using AmuseYou.BookingCore;
using AmuseYou.RentalOperations;

codeunit 50302 "Availability Performance Tests"
{
    Subtype = Test;

    [Test]
    procedure TestAvailabilityCheckPerformanceWithLargeDataset()
    var
        Equipment: Record Equipment;
        Booking: Record Booking;
        AvailabilityMgt: Codeunit AvailabilityMgt;
        TempAvailableEquipment: Record Equipment temporary;
        StartTime: DateTime;
        EndTime: DateTime;
        Duration: Duration;
        i: Integer;
    begin
        // [GIVEN] Large dataset of equipment and bookings
        for i := 1 to 100 do
            CreateTestEquipment(Equipment, 'PERF' + Format(i, 3, '<Integer,3><Filler Character,0>'));

        for i := 1 to 500 do
            CreateTestBooking(Booking, 'PERFBOOK' + Format(i, 4, '<Integer,4><Filler Character,0>'),
                'PERF' + Format((i mod 100) + 1, 3, '<Integer,3><Filler Character,0>'));

        // [WHEN] Checking availability across large dataset
        StartTime := CurrentDateTime();
        AvailabilityMgt.GetAvailableEquipment(EquipmentType::BounceUnit, Today(), Today() + 7, TempAvailableEquipment);
        EndTime := CurrentDateTime();

        // [THEN] Operation completes within acceptable time
        Duration := EndTime - StartTime;
        Assert.IsTrue(Duration < 5000, 'Availability check should complete in under 5 seconds');
    end;

    local procedure CreateTestEquipment(var Equipment: Record Equipment; EquipmentNo: Code[20])
    begin
        Equipment.Init();
        Equipment."No." := EquipmentNo;
        Equipment.Description := 'Performance Test Equipment';
        Equipment."Equipment Type" := EquipmentType::BounceUnit;
        Equipment."Daily Rental Rate" := 100;
        Equipment.Blocked := false;
        Equipment.Insert();
    end;

    local procedure CreateTestBooking(var Booking: Record Booking; BookingNo: Code[20]; EquipmentNo: Code[20])
    begin
        Booking.Init();
        Booking."Booking No." := BookingNo;
        Booking."Equipment No." := EquipmentNo;
        Booking."Customer Name" := 'Performance Test Customer';
        Booking."Start Date" := Today() + (Random(30));
        Booking."End Date" := Booking."Start Date" + Random(7);
        Booking.Status := BookingStatus::Confirmed;
        Booking.Insert();
    end;
}
