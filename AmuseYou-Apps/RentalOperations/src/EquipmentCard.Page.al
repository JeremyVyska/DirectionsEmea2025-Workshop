namespace AmuseYou.RentalOperations;

using AmuseYou.BookingCore;

page 50201 "Equipment Card"
{
    ApplicationArea = All;
    Caption = 'Equipment Card';
    PageType = Card;
    SourceTable = Equipment;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field("No."; Rec."No.")
                {
                }
                field(Description; Rec.Description)
                {
                }
                field("Equipment Type"; Rec."Equipment Type")
                {
                }
                field("Daily Rental Rate"; Rec."Daily Rental Rate")
                {
                }
                field(Status; Rec.Status)
                {
                }
                field(Blocked; Rec.Blocked)
                {
                }
                field("Last Maintenance Date"; Rec."Last Maintenance Date")
                {
                }
            }
        }
    }
}
