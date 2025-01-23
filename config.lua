Config = {}
Config.DefaultHygiene = 100
Config.HygieneDecreaseRate = 0.1 -- Decrease per second
Config.LowHygieneThreshold = 20 -- Threshold for low hygiene effects
Config.HygieneEffectsInterval = 30 -- Seconds between applying low hygiene effects
Config.WashAnimation = {
    dict = "amb@world_human_bum_wash@male@high@base",
    anim = "base",
    duration = 5000 -- Duration of the animation in milliseconds
}
Config.SinkAndShowerModels = {
    `prop_sink_02`, `prop_sink_03`, `prop_sink_04`, `prop_sink_05`, `prop_sink_06`,
    `prop_shower_panel`, `prop_shower_rack_01`, `prop_shower_towel`,
    `v_res_mbsink`, `v_res_fhshower`, `prop_sink_01`, `prop_sink_basin`,
    `v_ret_fhshower`
}

 -- Comprehensive list of sink and shower models
Config.PolyzoneRadius = 1.5 -- Radius for the polyzone around sinks and showers
