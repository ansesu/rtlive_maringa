library(base)
library(readxl)
library(EpiEstim)

df = read_excel("data/ts_maringa.xlsx")
df[['Data']] <- as.Date(df[['Data']], format='%d/%m/%Y')
df <- df[order(df$Data),]
df <- transform(df, cases = c(1, diff(Confirmados)))
df <- subset(df, Data> "2020-03-30")

incid=df[['cases']]
Rt = estimate_R(incid,
                method = "uncertain_si",
                config = make_config(
                    incid = incid,
                    method = method,
                    mean_si=4.8,
                    std_mean_si=1,
                    min_mean_si=1,
                    max_mean_si=8.6,
                    std_si=2.3,
                    std_std_si=1,
                    min_std_si=0.1,
                    max_std_si=4.5,
                    mean_prior=2.6,
                    std_prior=2
                    )
                )
write.csv2(Rt$R, 'data/rt_r.csv')
write.csv2(Rt$si_distr, 'data/parametric_si.csv')