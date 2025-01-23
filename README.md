# FiveM Hygiene and Stress System 

## This FiveM script allows players to open a menu to view their hygiene, stress, and health levels. The script includes functionalities to raise hygiene by swimming in water and reduce stress by smoking a joint or using a custom relief item. This system is designed with QBcore dependencies and utilizes ox_lib for the menu interface.

# Features 

* Player Menu: Open a menu to view hygiene, stress, and health levels. 

* Hygiene System: Raise hygiene by swimming in water. 

* Stress System: Reduce stress by smoking a joint or using a custom relief item. 

* Health Monitoring: Keep track of your health status. 

# Requirements

* FiveM 

* QBcore 

* ox_lib 

# Installation

* Download the script: Clone or download the repository to your local machine.


git clone https://github.com/your-repo/fivem-hygiene-stress-system.git
Add to your server: Copy the script folder into your server's resources directory.

Configure server.cfg: Add the following line to your server.cfg file to ensure the script starts with your server.


ensure fivem-hygiene-stress-system
Dependencies: Make sure you have qb-core and ox_lib installed and configured in your server.

# Usage

* Open Player Menu: Players can open the hygiene, stress, and health menu by using a specific command or key bind (configure as needed). 

* Increase Hygiene: Players can raise their hygiene levels by swimming in water. 

* Reduce Stress: Players can reduce their stress levels by smoking a joint or using a custom relief item defined in QBcore. 

# Customization

 You can customize the script to fit your server's needs by modifying the configuration files and adding custom relief items for stress reduction. 

# Contributing

We welcome contributions to improve this script! Please fork the repository and submit a pull request with your changes. 

---- Installation 

Made By BootStrap Devlopment

You will Require ox_lib 

-- Qb-radialmenu Intagration 

{
                id = 'Stats',
                title = 'Check Stats',
                icon = 'child',
                type = 'client',
                event = 'showStats',
                shouldClose = true
            },


sorry if this isnt the correct code first time interating qb-radialmenu

commands 

/stats command will open the stats menu to check your stats 

stress relife players can smoke joints to relive stress or you can config the scrtipt to have a diffrent stress relife method
