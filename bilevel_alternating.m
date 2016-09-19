clear 
clc;
warning = warning ('off','all');

m = 27;  %max = 27
n = 57;  %max = 57

a = 1;
b = 1;
c = 1;

w_csv = csvread('landprice.csv');
distance_csv = csvread('distance.csv');
pt_csv = csvread('parking_time.csv');
demand_csv = csvread('demand.csv');

w = cat(1);
p = cat(1);
distance = cat(1);
dis2 = cat(1);
pt = cat(1);
demand = cat(1);
demand_2 = cat(1);

x = sdpvar(1,n*m);
flow = sdpvar(1,n*n*m*m);
in = sdpvar(1,n*m);
out = sdpvar(1,n*m);
d = sdpvar(1,n*m);

for i=1:m
    for j=1:n
        pt((i-1)*n+j) = abs(120-pt_csv(i,j));
        demand((i-1)*n+j) = demand_csv(i,j);
        w((i-1)*n+j) = w_csv(i,j);
        if w_csv(i,j) == 9999
            p((i-1)*n+j) = 0;
        else
            p((i-1)*n+j) = 0.01*w_csv(i,j);
        end
    end
end

for i=1:n*m
    for j=1:n*m
        distance((i-1)*n*m+j) = distance_csv(i,j);
    end
end

for i=1:n*m
    disp(i)
    tic
    
    tempIn=0;
    tempOut=0;
    tempD=0;
    
    for j=1:n*m
        if distance((i-1)*n*m+j) ~= 999
            tempOut = tempOut + flow((i-1)*n*m+j);
            tempD = tempD + (flow((i-1)*n*m+j) * distance((i-1)*n*m+j));
        end
        if distance((j-1)*n*m+i) ~= 999
            tempIn = tempIn + flow((j-1)*n*m+i);
        end
    end
    
    out(i) = tempOut;
    d(i) = tempD;
    in(i) = tempIn;
    disp(['run time is: ',num2str(toc)]);
end

capacity = 100;
times = 3000;

for i=1:n*m
    assign(x(i),sum(demand)/(n*m));
end

OO1 = 0;
OI1 = 0;
time = 0;

disp(['Start optimize...']);
for k=1:times

    time = time + 1;
    
    OI = sum(d+1000000*abs(in-value(x))+in.*pt+p.*in);
    CI = [flow>=0,sum(in)==sum(value(x)), out-(demand)==0];
    optimize(CI, OI);

    OO = -1*(sum(p.*value(in)-(w.*x)-1000000*abs(value(in)-x)));   
    CO = [x-capacity<=0, x>=0, sum(x)-sum(value(in)) == 0];
    optimize(CO, OO);

    value(OO)
    value(OO1)

    value(OI)
    value(OI1)

    if abs(OO1-value(OO))<=0.01 && abs(OI1-value(OI))<=0.01
        break;
    end
    OO1 = value(OO);
    OI1 = value(OI);
end

var_x = cat(2);
var_in = cat(2);
var_demand = cat(2);
for i=1:m
    for j=1:n
        var_x(i,j) = value(x((i-1)*n+j));
        var_in(i,j) = value(in((i-1)*n+j));
        var_demand(i,j) = demand((i-1)*n+j);
    end
end

csvwrite('ICDM_2016/result/bilevel_output.csv', round(value(var_x),3));

fileID = fopen('ICDM_2016/result/bilevel_result.csv','w');
fprintf(fileID,'OO = %8f \nOI = %8f\n',value(OO),value(OI));
fclose(fileID);

disp(['Total iteration time is: ',num2str(time)]); % end time