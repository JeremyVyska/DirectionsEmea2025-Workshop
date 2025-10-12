namespace AmuseYou.RentalOperations;

using AmuseYou.BookingCore;

page 50202 "Booking List"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = Booking;
    Caption = 'Bookings';
    CardPageId = "Booking Card";

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Booking No."; Rec."Booking No.")
                {
                    ToolTip = 'Specifies the booking number.';
                }
                field("Equipment No."; Rec."Equipment No.")
                {
                    ToolTip = 'Specifies the equipment number.';
                }
                field("Customer Name"; Rec."Customer Name")
                {
                    ToolTip = 'Specifies the customer name.';
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
                field("Total Amount"; Rec."Total Amount")
                {
                    ToolTip = 'Specifies the total rental amount.';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(CreateNewBooking)
            {
                Caption = 'New Booking';
                Image = New;
                ToolTip = 'Creates a new booking record.';

                trigger OnAction()
                var
                    Booking: Record Booking;
                begin
                    Page.Run(Page::"Booking Card", Booking);
                end;
            }
        }
    }
}
