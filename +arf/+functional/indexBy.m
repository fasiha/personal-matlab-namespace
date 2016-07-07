
function v = indexBy(idx, arr)
% VAL = INDEXBY(INDEX, ARRAY)
%   Get the INDEX'th of ARRAY regardless of if it is a cell or not.
%
import functional.*; % Added by node for package support.

  if iscell(arr)
    v = arr{idx};
  else
    v = arr(idx);
  end
end
