#define SKY_BLOCKED 0
#define SKY_VISIBLE 1
#define SKY_VISIBLE_BORDER 2

#define PARTICLEWEATHER_RAIN "weather_rain"
#define PARTICLEWEATHER_SNOW "weather_snow"
#define PARTICLEWEATHER_BLOODRAIN "weather_blood"

#define MAX_LAYER_SNOW_LEVELS 3

GLOBAL_LIST_EMPTY(weather_act_upon_list)

/// Weather immunities, also protect mobs inside them.
#define TRAIT_SNOWSTORM_IMMUNE "snowstorm_immune"
#define TRAIT_WEATHER_IMMUNE "weather_immune" //Immune to ALL weather effects.
#define TRAIT_RAINSTORM_IMMUNE "rainstorm_immune"

#define SUNLIGHT_DARK_MATRIX \
	list                     \
	(                        \
		0, 0, 0, 0, \
		0, 0, 0, 0, \
		0, 0, 0, 0, \
		0, 0, 0, 0, \
		0, 0, 0, 1           \
	)
