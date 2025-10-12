namespace AmuseYou.RentalOperations;

using AmuseYou.BookingCore;

page 50203 "Booking Card"
{
    PageType = Card;
    ApplicationArea = All;
    SourceTable = Booking;
    Caption = 'Booking Card';

    layout
    {
        area(Content)
        {
            field("Booking No."; Rec."Booking No.")
            {
                ToolTip = 'Specifies the booking number.';
            }
            field("Total Amount"; Rec."Total Amount")
            {
                ToolTip = 'Specifies the total rental amount.';
            }
            field("Customer Name"; Rec."Customer Name")
            {
                ToolTip = 'Specifies the customer name.';
            }
            field("Equipment No."; Rec."Equipment No.")
            {
                ToolTip = 'Specifies the equipment number.';
            }
            field("Start Date"; Rec."Start Date")
            {
                ToolTip = 'Specifies the rental start date.';
            }
            field("End Date"; Rec."End Date")
            {
                ToolTip = 'Specifies the rental end date.';
            }
            field(Status; Rec.Status)
            {
                ToolTip = 'Specifies the booking status.';
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ConfirmBooking)
            {
                Caption = 'Confirm Booking';
                Image = Approve;
                ToolTip = 'Confirms the booking.';

                trigger OnAction()
                var
                    BookingMgt: Codeunit BookingMgt;
                begin
                    BookingMgt.UpdateBookingStatus(Rec."Booking No.", BookingStatus::Confirmed);
                    CurrPage.Update(false);
                end;
            }
            action(CancelBooking)
            {
                Caption = 'Cancel Booking';
                Image = Cancel;
                ToolTip = 'Cancels the booking.';

                trigger OnAction()
                var
                    BookingMgt: Codeunit BookingMgt;
                begin
                    BookingMgt.CancelBooking(Rec."Booking No.");
                    CurrPage.Update(false);
                end;
            }
        }
    }
}
