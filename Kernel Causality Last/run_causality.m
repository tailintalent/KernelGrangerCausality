function [cb, ifail, rr, pp]=run_causality(filename,type,par,m)
% Process the data into the correct format:

X_filename = strcat(filename, "_X.csv");
y_filename = strcat(filename, "_y.csv");

X_train = csvread(X_filename);
y_train = csvread(y_filename);

[n, nvar_times_m] = size(X_train);
nvar = nvar_times_m / m;
X = reshape(X_train, n, nvar, m);
X = permute(X, [2,3,1]);
X = flip(X,2);
x = y_train;
% 
Xm=reshape(repmat(mean(X,3),1,n),nvar,m,n);
X=X-Xm;
xm=repmat(mean(x,1),n,1);
x=x-xm;
x=x./repmat(sqrt(diag(x'*x)'),n,1);

% Final:
[nvar m n]=size(X);
f=1.e-6;
th=0.05;
Xr=reshape(X,nvar*m,n);
[VV D ifail]=filtro(Xr,type,par,f,true);
cb=zeros(nvar,nvar);
VT=VV*D.^0.5;
polycall=true;
kk=0;
for i=1:nvar
    XX=X;
    XX(i,:,:)=[];
    Xr=reshape(XX,(nvar-1)*m,n);
    V=filtro(Xr,type,par,f,polycall);
    polycall=false;
    [VN ifail]=vnorma(VT,V,VV);
    if ifail>0
        rr=0;
        pp=0;
        return
    end
    xv=x-V*V'*x;
    [rrt ppt]=corr(xv,VN);
    [nr nc]=size(rrt);
    rr(i,1:nr,1:nc)=rrt;
    pp(i,1:nr,1:nc)=ppt;
    rr(i,i,1:nc)=0;
    kk=kk+(nr-1)*nc;
end
rn=rr.^2;
thb=th/kk;
indpr=find(pp>thb);
rn(indpr)=0;
cb=sum(rn,3);

end