namespace AmuseYou.BookingCore;

interface IBookingProvider
{
    procedure CreateBooking(var Booking: Record Booking): Boolean;
    procedure UpdateBookingStatus(BookingNo: Code[20]; NewStatus: Enum BookingStatus): Boolean;
    procedure CancelBooking(BookingNo: Code[20]): Boolean;
}
