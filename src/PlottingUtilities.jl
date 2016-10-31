


function layersGroundTruth1D(gt::DataGroundTruth)
	PL = []
	push!(PL, gt.plt_lyr_cluster[1])
	push!(PL, gt.plt_lyr_cluster[2])
	PL
end

function layersExpertBelief1D(cs::ClassificationSystem;
															margdim=1,
															colors::VoidUnion{Dict{Int, ASCIIString}}=nothing )
	# use defaults
	colors = colors == nothing ? cs.colors : colors

  # prep data
	pr, cl = BallTreeDensity[], ASCIIString[]
	for p in cs.expertBelief
		push!(pr, marginal(p[2],[margdim]))
		push!(cl, colors[p[1]]) # get accompanying color
	end

	# plot and return layers
	pl_init = plotKDE(pr,c=cl);
	pl_init.layers
end

function layersCurrentBelief1D(cs::ClassificationSystem;
															margdim=1,
															colors::VoidUnion{Dict{Int, ASCIIString}}=nothing )
	# use defaults
	colors = colors == nothing ? cs.colors : colors

  # prep data
	pr, cl = BallTreeDensity[], ASCIIString[]
	for p in cs.currentBelief
		push!(pr, marginal(p[2],[margdim]))
		push!(cl, colors[p[1]]) # get accompanying color
	end

	# plot and return layers
	pl_init = plotKDE(pr,c=cl);
	pl_init.layers
end

function plotUtil1D(;
		sampledata::VoidUnion{SampleData}=nothing,
		groundtruth::VoidUnion{DataGroundTruth}=nothing,
		cs::VoidUnion{ClassificationSystem}=nothing,
		expertcolor::VoidUnion{Dict{Int,ASCIIString}}=nothing,
		drawcurrent::Bool=false,
		currentcolor::VoidUnion{Dict{Int,ASCIIString}}=nothing
		)

		PL = []
		PL = groundtruth == nothing ? PL : union(PL, layersGroundTruth1D(groundtruth))
		# push!(PL, Guide.title("True classification for intersecting clusters in 1 dimension"))

		PL = cs == nothing ? PL : union(PL, layersExpertBelief1D(cs, colors=expertcolor))

		PL = (cs == nothing || !drawcurrent) ? PL : union(PL, layersCurrentBelief1D(cs, colors=currentcolor))

		# layer(x=data.samples,y=zeros(size(data.samples)),Geom.point,Theme(default_color=colorant"gray")),

		plot(PL...)
end










function plotPopulationFraction(params, stats)
  plot(
  layer(x=1:params.EMiters, y=stats.POPFRAC[1,:], Geom.line, Theme(default_color=colorant"blue" )),
  layer(x=1:params.EMiters, y=stats.POPFRAC[2,:], Geom.line, Theme(default_color=colorant"red"  )),
  # layer(x=1:params.EMiters, y=abs(dbg.INDV_MISASSIGN_C[1] - dbg.INDV_MISASSIGN_C[2]), Geom.line, Theme(default_color=colorant"magenta"  )),
  Guide.title("Population fraction estimates"),
  Guide.ylabel("%")
  )
end

function plotClassificationStats(params, dbg)
  pl_accur = plot(
  layer(x=1:params.EMiters, y=dbg.ACCUR_C[1], Geom.line, Theme(default_color=colorant"blue" )),
  layer(x=1:params.EMiters, y=dbg.ACCUR_C[2], Geom.line, Theme(default_color=colorant"red"  )),
  Guide.title("Absolute percentage error in sample count among classifications"),
  Guide.ylabel("%")
  );

  pl_rel_accur = plot(
  layer(x=1:params.EMiters, y=dbg.REL_ACCUR_C[1], Geom.line, Theme(default_color=colorant"blue" )),
  layer(x=1:params.EMiters, y=dbg.REL_ACCUR_C[2], Geom.line, Theme(default_color=colorant"red"  )),
  Guide.title("Relative percentage error in sample count among classifications"),
  Guide.ylabel("%")
  );

  # pl_indvmissassign = plot(
  # layer(x=1:params.EMiters, y=dbg.INDV_MISASSIGN_C[1], Geom.line, Theme(default_color=colorant"blue" )),
  # layer(x=1:params.EMiters, y=dbg.INDV_MISASSIGN_C[2], Geom.line, Theme(default_color=colorant"red"  )),
  # # layer(x=1:params.EMiters, y=abs(dbg.INDV_MISASSIGN_C[1] - dbg.INDV_MISASSIGN_C[2]), Geom.line, Theme(default_color=colorant"magenta"  )),
  # Guide.title("Common percentage error count among classifications (unweighted)"),
  # Guide.ylabel("%")
  # );

  vstack(pl_accur, pl_rel_accur)
end