namespace AmuseYou.RentalOperations;

using AmuseYou.BookingCore;

page 50201 "Equipment Card"
{
    PageType = Card;
    ApplicationArea = All;
    SourceTable = Equipment;
    Caption = 'Equipment Card';

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the equipment number.';
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the equipment description.';
                }
                field("Equipment Type"; Rec."Equipment Type")
                {
                    ToolTip = 'Specifies the type of equipment.';
                }
                field("Daily Rental Rate"; Rec."Daily Rental Rate")
                {
                    ToolTip = 'Specifies the daily rental rate.';
                }
                field(Blocked; Rec.Blocked)
                {
                    ToolTip = 'Specifies if the equipment is blocked from booking.';
                }
                field("Last Maintenance Date"; Rec."Last Maintenance Date")
                {
                    ToolTip = 'Specifies the last maintenance date.';
                }
            }
        }
    }
}
