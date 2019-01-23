m = 3;
par = 2;
type = "p";

for nvar = [3, 4, 5, 8, 10, 15, 20, 30]
    for seed = [0, 30, 60, 90]
        strcat("N: ", num2str(nvar))
        strcat("seed: ", num2str(seed))
        filename = strcat("datasets/synthetic/N_", num2str(nvar), "_K_", num2str(m), "_seed_", num2str(seed));

        [cb, ifail, rr, pp]=run_causality(filename,type,par,m);
        cb'
        filename_save = strcat("results/synthetic/N_", num2str(nvar), "_K_", num2str(m), "_seed_", num2str(seed), "_result.csv");
        csvwrite(filename_save, cb')
    end
end