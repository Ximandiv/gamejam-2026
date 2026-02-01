extends Resource
class_name PlayerStatus

@export var currentMask : PlayerMaskEnum.Value = PlayerMaskEnum.Value.NONE
@export var keyList : Array[PlayerKeysEnum.Value]
@export var hasSilenceMask := false
@export var isMoving := false
@export var isEquipingMask := false
