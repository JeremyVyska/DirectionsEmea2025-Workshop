namespace AmuseYou.RentalOperations;

using AmuseYou.BookingCore;

page 50204 "Booking Webhook API"
{
    PageType = API;
    Caption = 'Booking Webhook API';
    APIPublisher = 'directionsemea2025';
    APIGroup = 'rental';
    APIVersion = 'v1.0';
    EntityName = 'booking';
    EntitySetName = 'bookings';
    SourceTable = Booking;
    DelayedInsert = true;
    ODataKeyFields = "Booking No.";

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field(bookingNo; Rec."Booking No.")
                {
                    Caption = 'Booking No.';
                }
                field(equipmentNo; Rec."Equipment No.")
                {
                    Caption = 'Equipment No.';
                }
                field(customerName; Rec."Customer Name")
                {
                    Caption = 'Customer Name';
                }
                field(startDate; Rec."Start Date")
                {
                    Caption = 'Start Date';
                }
                field(endDate; Rec."End Date")
                {
                    Caption = 'End Date';
                }
                field(status; Rec.Status)
                {
                    Caption = 'Status';
                }
                field(totalAmount; Rec."Total Amount")
                {
                    Caption = 'Total Amount';
                }
            }
        }
    }
}
