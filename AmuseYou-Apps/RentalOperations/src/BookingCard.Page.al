namespace AmuseYou.RentalOperations;

using AmuseYou.BookingCore;

page 50203 "Booking Card"
{
    ApplicationArea = All;
    Caption = 'Booking Card';
    PageType = Card;
    SourceTable = Booking;

    layout
    {
        area(Content)
        {
            field("Booking No."; Rec."Booking No.")
            {
            }
            field("Total Amount"; Rec."Total Amount")
            {
            }
            field("Customer Name"; Rec."Customer Name")
            {
            }
            field("Customer Email"; Rec."Customer Email")
            {
            }
            field("Equipment No."; Rec."Equipment No.")
            {
            }
            field("Start Date"; Rec."Start Date")
            {
            }
            field("End Date"; Rec."End Date")
            {
            }
            field(Status; Rec.Status)
            {
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
