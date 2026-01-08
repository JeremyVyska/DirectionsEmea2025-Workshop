namespace AmuseYou.BookingCore.Test;

using AmuseYou.BookingCore;

codeunit 50101 "Booking Tests"
{
    Subtype = Test;

    [Test]
    procedure TestBookingCreation()
    var
        Booking: Record Booking;
    begin
        // [GIVEN] A new booking record
        Booking.Init();
        Booking."Booking No." := 'BOOK001';
        Booking."Equipment No." := 'BOUNCE001';
        Booking."Customer Name" := 'John Doe';
        Booking."Start Date" := Today();
        Booking."End Date" := Today() + 2;
        Booking.Status := BookingStatus::Pending;

        // [WHEN] The booking is inserted
        Booking.Insert();

        // [THEN] The booking record exists
        Assert.IsTrue(Booking.Get('BOOK001'), 'Booking should exist after insert');
    end;

    [Test]
    procedure TestBookingStatusChange()
    var
        Booking: Record Booking;
    begin
        // [GIVEN] An existing pending booking
        CreateTestBooking(Booking, 'BOOK002', BookingStatus::Pending);

        // [WHEN] Status is changed to confirmed
        Booking.Status := BookingStatus::Confirmed;
        Booking.Modify();

        // [THEN] Booking status is confirmed
        Booking.Get('BOOK002');
        Assert.AreEqual(BookingStatus::Confirmed, Booking.Status, 'Booking should be confirmed');
    end;

    [Test]
    procedure TestLastCancelDateCalculation()
    var
        Booking: Record Booking;
        StartDate: Date;
        ExpectedCancelDate: Date;
    begin
        // [GIVEN] A start date
        StartDate := Today() + 10;
        ExpectedCancelDate := StartDate - 3;

        // [WHEN] Creating a booking with a start date
        Booking.Init();
        Booking."Booking No." := 'BOOK003';
        Booking."Equipment No." := 'TEST001';
        Booking."Customer Name" := 'Test Customer';
        Booking."Start Date" := StartDate;
        Booking."End Date" := StartDate + 2;
        Booking.Status := BookingStatus::Pending;
        Booking.Insert();

        // [THEN] Last Cancel Date should be Start Date minus 3 days
        Booking.Get('BOOK003');
        Assert.AreEqual(ExpectedCancelDate, Booking."Last Cancel Date", 'Last Cancel Date should be Start Date minus 3 days');
    end;

    local procedure CreateTestBooking(var Booking: Record Booking; BookingNo: Code[20]; Status: Enum BookingStatus)
    begin
        Booking.Init();
        Booking."Booking No." := BookingNo;
        Booking."Equipment No." := 'TEST001';
        Booking."Customer Name" := 'Test Customer';
        Booking."Start Date" := Today();
        Booking."End Date" := Today() + 1;
        Booking.Status := Status;
        Booking.Insert();
    end;
}
