namespace AmuseYou.BookingCore.Test;

using AmuseYou.BookingCore;

codeunit 50100 "Equipment Tests"
{
    Subtype = Test;

    [Test]
    procedure TestEquipmentCreation()
    var
        Equipment: Record Equipment;
        equipmentNo: Code[20];
        equipment_type: Enum EquipmentType;
        DailyRate: Decimal;
    begin
        // [GIVEN] A new equipment record
        equipmentNo := 'BOUNCE001';
        equipment_type := EquipmentType::BounceUnit;
        DailyRate := 150;

        Equipment.Init();
        Equipment."No." := equipmentNo;
        Equipment.Description := 'Castle Bouncer';
        Equipment."Equipment Type" := equipment_type;
        Equipment."Daily Rental Rate" := DailyRate;

        // [WHEN] The equipment is inserted
        Equipment.Insert();

        // [THEN] The equipment record exists
        Assert.IsTrue(Equipment.Get(equipmentNo), 'Equipment should exist after insert');
    end;

    [Test]
    procedure TestEquipmentBlocking()
    var
        Equipment: Record Equipment;
    begin
        // [GIVEN] An existing equipment record
        CreateTestEquipment(Equipment, 'GOKART001', EquipmentType::GoKartExperience);

        // [WHEN] Equipment is blocked
        Equipment.Blocked := true;
        Equipment.Modify();

        // [THEN] Equipment is marked as blocked
        Equipment.Get('GOKART001');
        Assert.IsTrue(Equipment.Blocked, 'Equipment should be blocked');
    end;

    local procedure CreateTestEquipment(var Equipment: Record Equipment; EquipmentNo: Code[20]; EquipmentType: Enum EquipmentType)
    begin
        Equipment.Init();
        Equipment."No." := EquipmentNo;
        Equipment.Description := 'Test Equipment';
        Equipment."Equipment Type" := EquipmentType;
        Equipment."Daily Rental Rate" := 100;
        Equipment.Insert();
    end;
}
