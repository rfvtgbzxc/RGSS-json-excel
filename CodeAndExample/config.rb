module ExcelToRxdataConfig
  BindFiles = {
    'Actors'=> 'AllAvailable',
    #'Actors'=> ['id','name','class_id'],
    'Enemies'=> 'AllAvailable',
    'Weapons'=> 'AllAvailable',
  }
  Attributes = {
    'Actors'=> {
      'id'=> 'id',
      'initial_level'=>'初始等级',
      'final_level'=>'最终等级',
      'name'=>'名称',
      'class_id'=>'职业',
      'character_name'=>'角色脸谱',
      'battler_name'=>'战斗图',
      'character_hue'=>'脸谱色相',
      'battler_hue'=>'战斗图色相',
      'exp_basis'=>'经验基础值',
      'exp_inflation'=>'经验成长度',
      'weapon_id'=>'武器',
      'armor1_id'=>'盾',
      'armor2_id'=>'头部防具',
      'armor3_id'=>'身体防具',
      'armor4_id'=>'装饰品',
      'weapon_fix'=>{
        'type' => 'bool',
        'name' => '固定武器'
      },
      'armor1_fix'=>{
        'type' => 'bool',
        'name' => '固定盾'
      },
      'armor2_fix'=>{
        'type' => 'bool',
        'name' => '固定头部防具'
      },
      'armor3_fix'=>{
        'type' => 'bool',
        'name' => '固定身体防具'
      },
      'armor4_fix'=>{
        'type' => 'bool',
        'name' => '固定装饰品'
      }
    },
    'Enemies'=> {
      'id'=>'id',
      'name'=>'名称',
      'maxhp'=>'MaxHP',
      'maxsp'=>'MaxSP',
      'atk'=>'攻击力',
      'str'=>'力量',
      'dex'=>'灵巧',
      'agi'=>'速度',
      'int'=>'魔力',
      'pdef'=>'物理防御',
      'mdef'=>'魔法防御',
      'eva'=>'回避修正',
      'exp'=>'EXP',
      'gold'=>'金钱',
      'weapon_id'=>'宝物-武器',
      'armor_id'=>'宝物-防具',
      'item_id'=>'宝物-物品',
      'treasure_prob'=>'掉落率',
      'battler_name'=>'战斗图',
      'battler_hue'=>'战斗图色相',
      'animation1_id'=>'攻击方动画',
      'animation2_id'=>'对象方动画',
    },
    'Weapons'=>{
      'id'=>'id',
      'name'=>'名称',
      'price'=>'价格',
      'atk'=>'攻击力',
      'pdef'=>'物理防御',
      'mdef'=>'魔法防御',
      'str_plus'=>'力量',
      'dex_plus'=>'灵巧',
      'agi_plus'=>'速度',
      'int_plus'=>'魔力',
      'description'=>'说明',
      'icon_name'=>'图标',
      'animation1_id'=>'攻击动画',
      'animation2_id'=>'对象动画',
    },
  }
end