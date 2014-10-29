minetest.register_chatcommand("test1", {
  params = "",
  description = "Test 1: Modify player's inventory view",
  func = function(name, param)
    local player = minetest.get_player_by_name(name)
    if not player then
      return
    end
    player:set_inventory_formspec(
      "size[13,7.5]"..
      "image[6,0.6;1,2;player.png]"..
      "list[current_player;main;5,3.5;8,4;]"..
      "list[current_player;craft;8,0;3,3;]"..
      "list[current_player;craftpreview;12,1;1,1;]"..
      "list[detached:test_inventory;main;0,0;4,6;0]"..
      "button[0.5,7;2,1;button1;Button 1]"..
      "button_exit[2.5,7;2,1;button2;Exit Button]"
    )
    minetest.chat_send_player(name, "Done.");
  end,
})
