%% load model
task1_model = readCbModel('iAF1260.xml');

%% including off blocked reactions

fid = fopen('iAF1260_off_reactions_aero.txt');
tline = fgetl(fid);

blockedRxnNameList = [];

while ischar(tline)
    disp(tline)
    blockedRxnNameList = [blockedRxnNameList tline];
    tline = fgetl(fid);
end

task1_model = changeRxnBounds(task1_model, blockedRxnNameList, 0, 'b');

%% convert a whole model to an irreversible model
[modelIrrev, matchRev, rev2irrev, irrev2rev] = convertToIrreversible(task1_model);

%%
writeCbModel(modelIrrev)
%% find biomass -> vj

d_coupled = [];
changeCobraSolver('gurobi','all')

for id = modelIrrev.rxns'
    temp_model = changeRxnBounds(modelIrrev, id, 1, 'b');
    changeObjective(temp_model, 'Ec_biomass_iAF1260_WT_59p81M', 1)
    solution = optimizeCbModel(temp_model, 'max')


end
