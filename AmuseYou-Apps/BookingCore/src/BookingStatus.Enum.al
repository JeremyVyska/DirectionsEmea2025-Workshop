namespace AmuseYou.BookingCore;

/// <summary>
/// Booking Status: Pending (<24 hours), Confirmed (>24 hours), Active (in progress)
/// </summary>
enum 50001 BookingStatus
{
    Extensible = true;

    value(0; Pending)
    {
        Caption = 'Pending';
    }
    value(1; Confirmed)
    {
        Caption = 'Confirmed';
    }
    value(2; InProgress)
    {
        Caption = 'In Progress';
    }
    value(3; Completed)
    {
        Caption = 'Completed';
    }
    value(4; Cancelled)
    {
        Caption = 'Cancelled';
    }
}
