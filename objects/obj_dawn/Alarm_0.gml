if(ROOT.state.day < 6) {
    ROOT.goto_day(ROOT.state.day + 1)
    GAME.reset()
} else {
    room_goto(rm_cutscene_outro)
}