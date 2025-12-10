namespace AmuseYou.BookingCore;

enum 50002 EquipmentStatus
{
    Caption = 'Equipment Status';
    Extensible = true;

    value(0; " ")
    {
        Caption = ' ', Locked = true;
    }
    value(1; Available)
    {
        Caption = 'Available';
    }
    value(2; "In Use")
    {
        Caption = 'In Use';
    }
    value(3; "Under Maintenance")
    {
        Caption = 'Under Maintenance';
    }
}
