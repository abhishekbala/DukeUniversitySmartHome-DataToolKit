function out = urlfilter(url, target, numNumbers, direction)
    %URLFILTER  Scrape one or more numbers off of a web page
    %   num = urlfilter(url, target) returns the first number that appears
    %   after the target string.
    %   num = urlfilter(url, target, numNumbers) returns a list of numbers that
    %   appears after the target string.
    %   num = urlfilter(url, target, numNumbers, direction) target is the
    %   string that should appear right before the number in question. The
    %   algorithm will continue grabbing numbers until numNumbers have been
    %   grabbed or the end of the file has been reached.
    %   direction is the direction, either "forward" or "backward" to search
    %   from the target string. The default is "forward".
    %
    %   Numbers inside tag bodies (i.e. anything inside <..> angle braces) are
    %   ignored.
    %
    %   Example:
    %   url = 'http://www.mathworks.com/matlabcentral/trendy/Tutorial/trendco.html';
    %   urlfilter(url,'Total Widgets')
    
    % Copyright 2012-2013 The MathWorks, Inc.
    
    if nargin < 3
        numNumbers = 1;
    end
    
    if nargin < 4
        direction = 'forward';
    end
    
    % If url is not an actual URL, then treat it as a string
    if strcmp(url(1:4),'http'),
        textStr = urlread(url);
    else
        textStr = url;
    end
       
    strIndex = strfind(textStr,target);
    
    if isempty(strIndex),
        error( 'trendy:urlfilter:TargetStringNotFound', ...
            ['Target string ' target ' does not appear'])
    end
    
    % Handle special case where two numbers are given as part of a range
    %   Example: "annual rainfall = 20-40 inches"
    % Solution is a pre-processing step that replaces the dash with a space 
    %   Example: "annual rainfall = 20 40 inches"
    
    textStr = regexprep(textStr,'(\d+)-(\d+)','$1 $2');
    
    % Start looking after the first appearance of the target
    if strcmp(direction,'forward')
        strIndex = strIndex(1) + length(target);
    elseif strcmp(direction,'backward')
        strIndex = strIndex(1) - 1;
    else
        error( 'trendy:urlfilter:InvalidDirectionFlag', ...
            'DIRECTION must be either ''forward'' or ''backward''.' );
    end
    
    out = zeros(1,numNumbers);
    for i = 1:numNumbers
        [out(i),strIndex] = getNextNumber(textStr,strIndex,direction);
    end
    
end


% =========================================================================
function [nextNumber,strIndex] = getNextNumber(textStr,strIndex,direction)
    % Use a state machine to sift through the HTML for numbers.
    
    if strcmp(direction,'forward')
        openTagSymbol  = '<';
        closeTagSymbol = '>';
        moveIndexFcn   = @(x) x+1;
        concatenateFcn = @(a,b) [a b];
    else
        openTagSymbol  = '>';
        closeTagSymbol = '<';
        moveIndexFcn   = @(x) x-1;
        concatenateFcn = @(a,b) [b a];
    end
    
    urlStrLen = length(textStr);
    state = 'notnumber';
    
    while true
        
        ch = textStr(strIndex);
        
        switch state
            case 'notnumber'
                if isDigitDotDashOrComma(ch)
                    state = 'number';
                    numStr = ch;
                elseif (ch == openTagSymbol)
                    state = 'tagbody';
                end
                
            case 'tagbody'
                % Throw away anything inside the tag markup area
                if (ch == closeTagSymbol)
                    state = 'notnumber';
                end
                
            case 'number'
                if isDigitDotDashOrComma(ch)
                    numStr = concatenateFcn(numStr,ch);
                else
                    % We are transitioning out of a number.
                    % Note that STR2DOUBLE handles commas in the string.
                    nextNumber = str2double(numStr);
                    if ~isnan(nextNumber)
                        % The number is valid. We're all done.
                        break
                    else
                        % The number is bogus. Throw it away and continue.
                        if (ch == openTagSymbol)
                            state = 'tagbody';
                        else
                            state = 'notnumber';
                        end
                    end
                end
                
            otherwise
                error( 'trendy:urlfilter:InvalidState', ...
                    ['Encountered unknown state ' state])
                
        end
        
        strIndex = moveIndexFcn(strIndex);
        
        if (strIndex == 0) || (strIndex > urlStrLen)
            % We ran off the end of the string.
            disp('End of file reached.')
            break
        end
        
    end
    
    
end


% =========================================================================
function tf = isDigitDotDashOrComma(ch)
    
    tf = ((ch >= '0') && (ch <= '9')) || ...
            (ch == '.') || (ch == '-') || (ch == ',');

end
