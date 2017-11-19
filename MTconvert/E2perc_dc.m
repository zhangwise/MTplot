function perc_dc=E2perc_dc(E)
if iscell(E)
    for i=1:numel(E)
        perc_dc{i}=E2perc_dc( E{i});
    end
    perc_dc=reshape(perc_dc,size(E,1),size(E,2));
    return
elseif isstruct(E)
    if any(strcmpi(fieldnames(E),'perc_dc'))
        perc_dc=E.perc_dc;
        return
    elseif any(strcmpi(fieldnames(E),'E'))
        perc_dc=E2perc_dc(E.E);
        return
    elseif any(strcmpi(fieldnames(E),'g'))&&any(strcmpi(fieldnames(E),'d'))
        perc_dc=E2perc_dc(GD2E(E.g,E.d));
        return
    else
        [~,~,~,E]=MT2TNPE(E.MTSpace);
    end
end
E=E./kron(ones(1,size(E,2)),sqrt(sum(E.^2,2)));
eps=-min(abs((E-kron(ones(1,3),sum(E,2)/3))'))'./abs(max(abs((E-kron(ones(1,3),sum(E,2)/3))'))');
perc_iso=100*sum(E,2)./(3*abs(max(abs(E'))'));
perc_clvd=2*eps.*(100-abs(perc_iso));
perc_dc=100-abs(perc_iso)-abs(perc_clvd);
end