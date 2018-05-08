function varargout = uihelper(id, varargin)

    switch lower(id)
        case 'begin'
            [varargout{1:nargout}] = batch_begin(varargin{:});
        case 'incr'
            [varargout{1:nargout}] = batch_incr(varargin{:});
        case 'end'
            [varargout{1:nargout}] = batch_end(varargin{:});
        case 'submitted'
            [varargout{1:nargout}] = submitted(varargin{:});
        case 'pulled'
            [varargout{1:nargout}] = pulled(varargin{:});
        case 'sec2ydhms'
            [varargout{1:nargout}] = sec2ydhms(varargin{:});
    end

end

function start = batch_begin(total)
    n    = floor(log10(total)) + 1;
    s    = repmat(' ',1,n - 1);
    s    = [s '0 of ' num2str(total) ' finished'];
    date = datestr(now,'mmmm dd, yyyy HH:MM:SS');
    fprintf(1,'%s | %s',date,s);
    start = tic;
end

function batch_incr(cur,total)
% cur    - Current number of processed subjects
% total  - Total number of subjects

    n = floor(log10(total)) + 1;
    d = floor(log10(total)) - floor(log10(max(cur,1)));
    
    s = repmat('\b',1,n + (n - 1) + 14);
    s = [s repmat(' ',1,d)];
    s = [s num2str(cur)];
    s = [s ' of ' num2str(total) ' finished'];
    
    fprintf(1,s);
end


function batch_end(total, start)
    dur = sec2ydhms(toc(start));
    date = datestr(now,'mmmm dd, yyyy HH:MM:SS');
    fprintf(' \n');
    fprintf([sprintf('%s | %d jobs processes in ', date, total) dur '\n']);
end

function submitted(N, batch)            
    date = datestr(now,'mmmm dd, yyyy HH:MM:SS');
    if batch
        fprintf('%s | Batch job submitted to cluster (N = %i)\n', date, N);
    else
        fprintf('%s | Individual jobs submitted to cluster (N = %i)\n', date, N);
    end
end

function pulled(dur)
    dur = sec2ydhms(dur);
    date = datestr(now,'mmmm dd, yyyy HH:MM:SS');
    fprintf([sprintf('%s | Data pulled in ', date) dur '\n']);
end

function str_end_2 = sec2ydhms(time)

    dur = duration(0,0,time);
    elapsed = floor(years(dur));
    dur = dur - years(elapsed(end));
    elapsed = [elapsed floor(days(dur))];
    dur = dur - days(elapsed(end));
    elapsed = [elapsed floor(hours(dur))];
    dur = dur - hours(elapsed(end));
    elapsed = [elapsed floor(minutes(dur))];
    dur = dur - minutes(elapsed(end));
    elapsed = [elapsed floor(seconds(dur))];
    units   = {'year' 'day' 'hour' 'minute' 'second'};
    str_end_2 = '';
    for i=1:numel(elapsed)
        if elapsed(i) > 0
            str_end_2 = [str_end_2 sprintf('%d %s', elapsed(i), units{i})];
            if elapsed(i) > 1
                str_end_2 = [str_end_2 's'];
            end
            if sum(elapsed(i+1:end)) > 0
                str_end_2 = [str_end_2 ', '];
            end
        end
    end
    if sum(elapsed) == 0
        str_end_2 = [str_end_2 '< 0 second'];
    end

end