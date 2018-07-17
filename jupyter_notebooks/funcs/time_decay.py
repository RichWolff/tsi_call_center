from scipy.optimize import minimize
import pandas as pd
import numpy as np

def time_decay(feature,target,periods=4):
    '''Returns the ideal time decay to maximize the correlation between ad spend and target value
    Parameters
    ----------
    feature: pandas series of variable we want to maximize (must be same depth as target)
    target: pandas series that we want to maximize the correlation of feature to  (must be same depth as feature)
    periods: Number of periods back we want to maximize, default 4

    Returns
    -------
    1.) pandas sereies containing Updated Series with correlation to target maximized
    2.) New Correlation of the new series
    3.) Percentages applied to each period to maximize correlation
    '''
    assert periods > 1, "Periods Must Be Greater Than 1"
    assert type(feature) is pd.Series, "series must be a pandas series"
    assert type(target) is pd.Series, "series must be a pandas series"
    assert len(feature) == len(target), "Feature and Target length must be equal Feature: {}, Target: {}".format(len(feature),len(target))

    def corr(params):
        params = np.array(params)
        shift = (shifted_data * params).fillna(0)
        return -np.corrcoef(x=shift.sum(axis=1),y=target)[0][1]

    shifted_data = pd.DataFrame([feature.shift(i) for i in range(periods)]).T
    shifted_data.columns = range(periods)

    cons = [{'type':'eq', 'fun': lambda x: x[0]-1},
            {'type':'ineq','fun': lambda x: x[0]-x[1]},
            {'type':'ineq','fun': lambda x: x[1]-x[2]},
            {'type':'ineq','fun': lambda x: x[2]-x[3]},]

    cons2 =[{'type':'eq', 'fun': lambda x: x[0]-1}]

    for j in range(1,periods):
        a = {'type':'ineq', 'fun': lambda x,j=j: x[j-1] - x[j]-.001}
        cons2.append(a)

    bounds = [(0,1) for _ in range(periods)]
    init_vars = [1]*periods

    result = minimize(corr,
                      init_vars,
                      method='SLSQP',
                      bounds=bounds,
                      constraints=cons2,
                      tol=1e-10000,
                      options={'maxiter': 100, 'ftol': 1e-100, 'iprint': 1, 'disp': False, 'eps': 1.4901161193847656e-08})

    corr = -result['fun']
    pers = result['x']
    shifted_series = shifted_data * pers

    return shifted_series.sum(axis=1),corr , pers,

def time_decay_bruteforce(ftr,tgt,periods=4,max_coef='last_coef',scorer='corrcoef'):
    '''PARAMETERS:
            ftr: pandas series of feature to maximize
            tgt: panads series of feature to maximize ftr too
            periods: number of periods to maximize in the past
            max_coef: Identifies method for max coefficient of any given period. last_coef: any period is <= the coef of the last period.
                      if integer, the max coef for any period will be that
            scorer: score type to use to maximize the ftr to tgt. Options: 'corrcoef' for Pearson Correlation Coefficient, 'rmse' for root
                    mean square error of a np.polyfit line, and 'r2' for the r2 score of the np.polyfit line.
       RETURNS:
           DICT of
               the new feature, key:'new_feature'
               the coeffecients to apply to different periods, key:'period_coefficients'
               the scores for each period, key'scores'


    '''
    assert (max_coef=='last_coef') or (type(max_coef)==int), "max_coef must be 'last_coef' or an integer"
    assert scorer in ('corrcoef','rmse','r2')

    ## DEFAULT SCORER
    def corrcoef(ftr,tg):
        return np.corrcoef(ftr,tgt)[0][1]


    def rmse(ftr,tgt,deg=1):
        from sklearn.metrics import mean_squared_error
        ## Get regression of line
        slope,intercept = np.polyfit(ftr,tgt,deg=deg)
        pred_tgt = [x*slope+intercept for x in ftr]
        return -np.sqrt(mean_squared_error(tgt,pred_tgt))

    def r2(ftr,tgt,deg=1):
        from sklearn.metrics import r2_score
        ## Get regression of line
        slope,intercept = np.polyfit(ftr,tgt,deg=deg)
        pred_tgt = [x*slope+intercept for x in ftr]
        return r2_score(tgt,pred_tgt)

    if scorer == 'corrcoef':
        scorer_obeject = corrcoef
    elif scorer == 'rmse':
        scorer_obeject = rmse
    elif scorer == 'r2':
        scorer_obeject = r2

    ## SEED INITIAL COEFFICIENT.
    coef = 1

    ## Make feature shift to the number of periods listed
    tst = pd.DataFrame([ftr.shift(period).copy() for period in range(periods)]).T
    tst.columns = range(periods)

    ## HOLDER TO CATCH COEFFICIENTS TO MAXIMIZE TIME DECAY
    period_coefficient = np.empty(periods,dtype=np.float)
    period_coefficient[0] = 1

    period_correlation = np.empty(periods,dtype=np.float)
    period_correlation[0] = scorer_obeject(ftr,tgt)

    for period in range(1,periods):

        # GET SUM OF FEATURE PRIOR TO CURRENT PERIOD
        prev_total = tst.iloc[:,:period].sum(axis=1)

        # SET CORRS TO CHECK
        pers_to_check = np.linspace(coef if max_coef =='last_coef' else max_coef,0.0,1000,dtype=np.float)
        corrs = np.empty(len(pers_to_check),dtype=np.float)
        pers = np.empty(len(pers_to_check),dtype=np.float)

        ## FOR EVERY COEFFICIENT TO CHECK, ADD PREVIOUS TOTAL TO EACH CURRENT PERIOD MULITPLIED BY CURRENT COEFFICIENT
        for i , c in enumerate(pers_to_check):
            corrs[i] = scorer_obeject(prev_total + (tst.iloc[:,period].fillna(0) * c),tgt)
            pers[i] = c

        #STORE COEF WITH MAX CORRELATION
        coef = pers[corrs.argmax()]

        #STORE COEFFICIENT FOR EACH PERIOD
        period_coefficient[period] = coef
        period_correlation[period] = corrs[corrs.argmax()]

        #UPDATE TST DATAFRAME WITH NEW COEF
        tst.iloc[:,period] = tst.iloc[:,period].fillna(0) * coef

    return {'new_feature':tst.sum(axis=1), 'period_coefficients':period_coefficient, 'scores':period_correlation}
