function model = build_model(tag)
% Synthetic steady heat-conduction benchmark; all quantities use SI units.
import com.comsol.model.util.*
model = ModelUtil.create(tag);
model.label('AutoCOMSOL steady conduction acceptance');
model.param.set('L', '0.1[m]');
model.param.set('H', '0.02[m]');
model.param.set('k0', '10[W/(m*K)]');
model.param.set('T_left', '400[K]');
model.param.set('T_right', '300[K]');
comp = model.component.create('comp1', true);
geom = comp.geom.create('geom1', 2);
geom.lengthUnit('m');
geom.create('r1', 'Rectangle');
geom.feature('r1').set('size', {'L','H'});
geom.run;
tol = 1e-7;
left = mphselectbox(model, 'geom1', [-tol,tol;-tol,0.02+tol], 'boundary');
right = mphselectbox(model, 'geom1', [0.1-tol,0.1+tol;-tol,0.02+tol], 'boundary');
assert(isscalar(left) && isscalar(right) && left~=right, ...
    'AutoCOMSOL:Selections', 'Expected one distinct boundary on each end.');
comp.selection.create('left', 'Explicit');
comp.selection('left').geom('geom1', 1);
comp.selection('left').set(left);
comp.selection.create('right', 'Explicit');
comp.selection('right').geom('geom1', 1);
comp.selection('right').set(right);
mat = comp.material.create('mat1', 'Common');
mat.propertyGroup('def').set('thermalconductivity', {'k0','0','0','0','k0','0','0','0','k0'});
mat.propertyGroup('def').set('density', '1000[kg/m^3]');
mat.propertyGroup('def').set('heatcapacity', '1000[J/(kg*K)]');
% Official COMSOL 6.3 LiveLink introduction: API id differs from UI label.
ht = comp.physics.create('ht', 'HeatTransfer', 'geom1');
ht.create('tempLeft', 'TemperatureBoundary', 1);
ht.feature('tempLeft').selection.named('left');
ht.feature('tempLeft').set('T0', 'T_left');
ht.create('tempRight', 'TemperatureBoundary', 1);
ht.feature('tempRight').selection.named('right');
ht.feature('tempRight').set('T0', 'T_right');
% The interface default insulation applies to the remaining boundaries.
comp.mesh.create('mesh1');
model.study.create('std1');
model.study('std1').create('stat', 'Stationary');
end
