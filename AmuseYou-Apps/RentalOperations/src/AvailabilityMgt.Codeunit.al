namespace AmuseYou.RentalOperations;

using AmuseYou.BookingCore;

codeunit 50200 AvailabilityMgt implements IAvailabilityCheck
{
    procedure IsEquipmentAvailable(EquipmentNo: Code[20]; StartDate: Date; EndDate: Date): Boolean
    var
        Equipment: Record Equipment;
        Booking: Record Booking;
    begin
        if not Equipment.Get(EquipmentNo) then
            exit(false);

        if Equipment.Blocked then
            exit(false);

        Booking.SetRange("Equipment No.", EquipmentNo);
        Booking.SetRange(Status, BookingStatus::Confirmed, BookingStatus::InProgress);
        Booking.SetFilter("Start Date", '<=%1', EndDate);
        Booking.SetFilter("End Date", '>=%1', StartDate);

        exit(Booking.IsEmpty());
    end;

    procedure GetAvailableEquipment(EquipmentType: Enum EquipmentType; StartDate: Date; EndDate: Date; var TempEquipment: Record Equipment temporary)
    var
        Equipment: Record Equipment;
    begin
        TempEquipment.Reset();
        TempEquipment.DeleteAll();

        Equipment.SetRange("Equipment Type", EquipmentType);
        Equipment.SetRange(Blocked, false);

        if Equipment.FindSet() then
            repeat
                if IsEquipmentAvailable(Equipment."No.", StartDate, EndDate) then begin
                    TempEquipment := Equipment;
                    TempEquipment.Insert();
                end;
            until Equipment.Next() = 0;
    end;

    procedure UpdateMaintenanceStatus()
    var
        Equipment: Record Equipment;
        UpdatedCount: Integer;
    begin
        if Equipment.FindSet(true) then
            repeat
                if Equipment."Last Maintenance Date" < CalcDate('<-6M>', Today) then begin
                    Equipment.Blocked := true;
                    Equipment.Modify();
                    Commit();
                    UpdatedCount += 1;
                end;
            until Equipment.Next() = 0;
    end;

    procedure GetTotalRevenue(): Decimal
    var
        Booking: Record Booking;
        Total: Decimal;
    begin
        Booking.SetRange(Status, BookingStatus::Completed);

        if Booking.FindSet() then
            repeat
                Total += Booking."Total Amount";
            until Booking.Next() = 0;

        exit(Total);
    end;
}
