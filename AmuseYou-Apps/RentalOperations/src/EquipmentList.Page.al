namespace AmuseYou.RentalOperations;

using AmuseYou.BookingCore;

page 50200 "Equipment List"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = Equipment;
    Caption = 'Equipment';
    CardPageId = "Equipment Card";

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
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
