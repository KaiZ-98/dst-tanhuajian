GLOBAL.setmetatable(env,{__index=function(t,k) return GLOBAL.rawget(GLOBAL,k) end})
PrefabFiles = {
	"tanhuajian",
}

-- Import things we like into our mod's own global scope, so we don't have
-- to type "GLOBAL." every time want to use them.
SpawnPrefab = GLOBAL.SpawnPrefab

--注意命名的时候必须是大写
--武器
STRINGS.NAMES.TANHUAJIAN = "昙花剑" --名字
STRINGS.RECIPE_DESC.TANHUAJIAN = "昙花做成的剑，威力杠杠的，攻击带暴击+吸血，可作祟复活，右键释放小旋风" --配方上面的描述
STRINGS.CHARACTERS.GENERIC.DESCRIBE.TANHUAJIAN = "你值得拥有~" --人物检查的描述

AddRecipe("tanhuajian",                           --添加物品的配方
	{ Ingredient("spear", 2) , Ingredient("amulet", 1) ,Ingredient("cane", 1)}, --材料
	RECIPETABS.WAR, TECH.SCIENCE_TWO,             --制作栏和解锁的科技（这里是战斗，需要科学二本）
	nil, nil, nil, nil, nil,                      --是否有placer  是否有放置的间隔  科技锁  制作的数量（改成2就可以一次做两个） 需要的标签（比如女武神的配方需要女武神的自有标签才可以看得到）
	"images/inventoryimages/tanhuajian.xml",      --配方的贴图（跟物品栏使用同一个贴图）
	"tanhuajian.tex")



