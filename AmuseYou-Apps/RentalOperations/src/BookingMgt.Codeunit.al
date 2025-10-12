namespace AmuseYou.RentalOperations;

using AmuseYou.BookingCore;

codeunit 50201 BookingMgt implements IBookingProvider
{
    procedure CreateBooking(var Booking: Record Booking): Boolean
    var
        AvailabilityMgt: Codeunit AvailabilityMgt;
        Message: Text;
    begin
        if Booking."Booking No." = '' then
            Error('Booking number must be specified.');

        if not AvailabilityMgt.IsEquipmentAvailable(Booking."Equipment No.", Booking."Start Date", Booking."End Date") then
            Error('Equipment %1 is not available for the selected dates.', Booking."Equipment No.");

        Booking.Status := BookingStatus::Pending;
        CalculateBookingAmount(Booking);

        if Booking.Insert(true) then begin
            Message := StrSubstNo('Booking created: %1 for customer %2', Booking."Booking No.", Booking."Customer Name");
            exit(true);
        end;

        exit(false);
    end;

    procedure UpdateBookingStatus(BookingNo: Code[20]; NewStatus: Enum BookingStatus): Boolean
    var
        Booking: Record Booking;
    begin
        if not Booking.Get(BookingNo) then
            exit(false);

        Booking.Status := NewStatus;
        exit(Booking.Modify(true));
    end;

    procedure CancelBooking(BookingNo: Code[20]): Boolean
    begin
        exit(UpdateBookingStatus(BookingNo, BookingStatus::Cancelled));
    end;

    local procedure CalculateBookingAmount(var Booking: Record Booking)
    var
        Equipment: Record Equipment;
        DurationDays: Integer;
    begin
        if not Equipment.Get(Booking."Equipment No.") then
            exit;

        DurationDays := Booking."End Date" - Booking."Start Date" + 1;
        Booking."Total Amount" := Equipment."Daily Rental Rate" * DurationDays;
    end;

    procedure ProcessDailyBookings()
    var
        Booking: Record Booking;
        ProcessedCount: Integer;
    begin
        Booking.SetRange(Status, BookingStatus::Confirmed);
        Booking.SetFilter("Start Date", '%1', Today);

        if Booking.FindSet() then
            repeat
                Booking.Status := BookingStatus::InProgress;
                Booking.Modify();
                ProcessedCount += 1;
            until Booking.Next() = 0;
    end;

    procedure GetBooking(BookingNo: Code[20])
    var
        Booking: Record Booking;
    begin
        if Booking.Get(BookingNo) then begin
            Page.Run(Page::"Booking Card", Booking);
        end;
    end;
}
