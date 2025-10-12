namespace AmuseYou.BookingCore;

interface IAvailabilityCheck
{
    procedure IsEquipmentAvailable(EquipmentNo: Code[20]; StartDate: Date; EndDate: Date): Boolean;
    procedure GetAvailableEquipment(EquipmentType: Enum EquipmentType; StartDate: Date; EndDate: Date; var TempEquipment: Record Equipment temporary);
}
