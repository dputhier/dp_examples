	from plotnine import (ggplot, aes, geom_tile, 
							facet_grid, theme_bw, 
							scale_fill_gradientn, 
							theme,
							element_blank,
							element_rect)
	import plotnine
	import pandas as pd
	import io
	import requests
	from pandas import Categorical


	# Load the data.frame
	url = "https://raw.githubusercontent.com/dputhier/dp_examples/master/plotnine/df_example_2.txt"
	s= requests.get(url).content
	data = pd.read_csv(io.StringIO(s.decode('utf-8')), sep="\t", header=0)
	data = data.sort_values("cls")
	data.object = Categorical(data.object, categories=data.object.unique(), ordered=True)
	data.condition = Categorical(data.condition, categories=data.condition.unique(), ordered=True)
	data.cls = Categorical(data.cls, categories=data.cls.unique(), ordered=True)

	# Create a facetted diagram

	color_palette = "#d73027,#fc8d59,#fee090,#e0f3f8,#91bfdb,#253494"
	color_palette_list = color_palette.split(",")

	p = ggplot(data=data, mapping=aes('pos',
	                                  'object')
	                                  ) + geom_tile(aes(fill='value'))
	p += theme_bw()
	p += scale_fill_gradientn(colors=color_palette_list,
	                          name="Signal", na_value="#222222")

	p += plotnine.labels.xlab('position')
	p += plotnine.labels.ylab("object")

	p += theme(panel_grid_major=element_blank(),
	           panel_grid_minor=element_blank(),
	           panel_border=element_rect(colour="black", size=1))

	p +=  plotnine.facet_grid("cls~condition ",
	                          scales="free_y",
	                          space="free")

	p.save(filename='plot_dp.pdf')