module Naka
  module Models
    module Battle
      class MidnightBattle
        attr_accessor :enemy_ids, :enemy_hps, :fleet_hps

        def completed? ; true ; end

        def self.from_api(response)
          battle = new
          data = response[:api_data]
          max_hps = data[:api_maxhps]
          now_hps = data[:api_nowhps]
          battle.enemy_ids = data[:api_ship_ke].reject{|x| x == -1 }
          fleet_max_hps = max_hps[1, 6].reject{|x| x == -1}
          enemy_max_hps = max_hps[7, 6].reject{|x| x == -1}

          key = :api_hougeki
          if data[key]
            data[key][:api_df_list].zip(data[key][:api_damage]).each do |fire|
              unless fire.first == -1
                now_hps[fire.first.first] -= fire.last.select{|x| x > 0}.sum
              end
            end
          end

          fleet_current_hps = now_hps[1, fleet_max_hps.length]
          battle.fleet_hps = fleet_current_hps.map{|x| [0, x.ceil].max}.zip(fleet_max_hps)

          enemy_current_hps = now_hps[7, enemy_max_hps.length]
          battle.enemy_hps = enemy_current_hps.map{|x| [0, x.ceil].max}.zip(enemy_max_hps)
          battle
        end
      end
    end
  end
end
