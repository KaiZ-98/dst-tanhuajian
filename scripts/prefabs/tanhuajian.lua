-- 加载资源
local assets =
{
    Asset("ANIM", "anim/tanhuajian.zip"),      -- 资源路径 放地上的动画
    Asset("ANIM", "anim/swap_tanhuajian.zip"), -- 资源路径 拿在手上的动画
    Asset("ATLAS", "images/inventoryimages/tanhuajian.xml"),
    Asset("IMAGE", "images/inventoryimages/tanhuajian.tex"),
}

local function randomAttackNum()
    return math.ceil(math.random() * 100) + 68
end

local function getspawnlocation(inst, target)
    local x1, y1, z1 = inst.Transform:GetWorldPosition()
    local x2, y2, z2 = target.Transform:GetWorldPosition()
    return x1 + .15 * (x2 - x1), 0, z1 + .15 * (z2 - z1)
end

local function spawntornado(staff, target, pos)
    local tornado = SpawnPrefab("tornado")
    tornado.WINDSTAFF_CASTER = staff.components.inventoryitem.owner
    tornado.WINDSTAFF_CASTER_ISPLAYER = tornado.WINDSTAFF_CASTER ~= nil and tornado.WINDSTAFF_CASTER:HasTag("player")
    tornado.Transform:SetPosition(getspawnlocation(staff, target))
    tornado.Transform:SetScale(2, 2, 2)
    tornado.components.knownlocations:RememberLocation("target", target:GetPosition())

    if tornado.WINDSTAFF_CASTER_ISPLAYER then
        tornado.overridepkname = tornado.WINDSTAFF_CASTER:GetDisplayName()
        tornado.overridepkpet = true
    end
end

-- 在装备函数
local function onequip(inst, owner) -- 参数 （自己 ， 装备者）
    -- 这里定义了一个叫做 onequip 的函数 参数是（装备自己 ， 装备的这个装备的对象【人或者生物，或者武器】）
    owner.AnimState:OverrideSymbol("swap_object", "swap_tanhuajian", "tanhuajian")
    owner.SoundEmitter:PlaySound("dontstarve/wilson/equip_item_gold")
    -- 装备者 替换 动画
    owner.AnimState:Show("ARM_carry")
    -- 显示 装备者的大手
    owner.AnimState:Hide("ARM_normal")
    -- 隐藏 装备者的小手
end

-- 在卸下函数
local function onunequip(inst, owner)  -- 参数 （自己 ， 装备者）
    owner.AnimState:Hide("ARM_carry")  -- 隐藏装备者的大手
    owner.AnimState:Show("ARM_normal") -- 显示装备者的小手
end

local function onattack(inst, owner, target) --攻击函数(inst,owner,目标)
    if owner.components.health and owner.components.health:GetPercent() < 1 and not target:HasTag("wall") then
        local damage = randomAttackNum()
        inst.components.weapon:SetDamage(damage)
        --如果 生命组件存在 并且 获得生命百分比<100％ 并且	目标:含有标签【"wall"】
        owner.components.health:DoDelta(damage * 0.15)
        --Health:DoDelta(amount(数值), overtime(超时), cause(原因), ignore_invincible(无视无敌), afflicter(受折磨), ignore_absorb(忽略护甲))
    end
end

-- fn 函数  （或者 叫生成函数  主函数）
local function fn()
    local inst = CreateEntity()           -- 创建一个空白实体

    inst.entity:AddTransform()            -- 给空白实体添加 Transform 组件
    inst.entity:AddAnimState()            -- 给空白实体添加 AnimState 组件
    inst.entity:AddNetwork()              -- 给空白实体添加网络组件

    MakeInventoryPhysics(inst)            -- 给实体添加物理属性

    inst.AnimState:SetBank("tanhuajian")  -- 设置实体的动画 Bank
    inst.AnimState:SetBuild("tanhuajian") -- 设置实体的动画 Build
    inst.AnimState:PlayAnimation("idle")  -- 设置实体的动画 Animation
    --标签
    inst:AddTag("sharp")                  -- 添加标签 ：长矛是尖锐的
    inst:AddTag("pointy")                 -- 添加标签 ：长矛是尖尖的

    inst.entity:SetPristine()             -- 实体设定原始

    if not TheWorld.ismastersim then      -- 如果不是主机
        return inst                       -- 返回实体
    end

    inst:AddComponent("weapon")                -- 添加武器组件
    inst.components.weapon:SetDamage(68)       -- 设置伤害
    inst.components.weapon:SetRange(1, 2)
    inst.components.weapon.onattack = onattack --正在攻击

    inst:AddComponent("inspectable")           -- 添加检查组件

    inst:AddComponent("inventoryitem")         -- 添加仓库组件
    inst.components.inventoryitem.imagename = "tanhuajian"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/tanhuajian.xml"

    inst:AddComponent("equippable")                    -- 添加装备组件
    inst.components.equippable:SetOnEquip(onequip)     -- 设置在装备时执行的函数（在装备函数）
    inst.components.equippable:SetOnUnequip(onunequip) -- 设置在卸下时执行的函数（在卸下函数）
    inst.components.equippable.walkspeedmult = 1.25

    inst:AddComponent("spellcaster")
    inst.components.spellcaster.canuseontargets = true
    inst.components.spellcaster.canonlyuseonworkable = true
    inst.components.spellcaster.canonlyuseoncombat = true
    inst.components.spellcaster.quickcast = true
    inst.components.spellcaster:SetSpellFn(spawntornado)
    inst.components.spellcaster.castingstate = "castspell_tornado"

    inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_INSTANT_REZ)

    MakeInventoryFloatable(inst, "med", 0.15, 0.65) -- 飘在水上

    return inst                                     -- 返回实体
end

return Prefab("tanhuajian", fn, assets, {
    "tornado",
}) -- 返回预制体（名字， fn 函数 ，资源）
