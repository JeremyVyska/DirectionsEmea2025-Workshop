namespace AmuseYou.BookingCore;

/// <summary>
/// Booking Status: Pending (less than 24 hours), Confirmed (more than 24 hours), Active (in progress)
/// </summary>
enum 50001 BookingStatus
{
    Extensible = true;

    value(0; " ")
    {
        Caption = ' ', Locked = true;
    }
    value(1; Pending)
    {
        Caption = 'Pending';
    }
    value(2; Confirmed)
    {
        Caption = 'Confirmed';
    }
    value(3; InProgress)
    {
        Caption = 'In Progress';
    }
    value(4; Completed)
    {
        Caption = 'Completed';
    }
    value(5; Cancelled)
    {
        Caption = 'Cancelled';
    }
}
