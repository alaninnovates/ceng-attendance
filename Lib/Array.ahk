ca_ArrJoin(arr, sep) {
    result := ""
    for i, v in arr {
        result .= (i > 1 ? sep : "") . v
    }
    return result
}

ca_ArrContains(arr, value) {
    for v in arr {
        if (v == value) {
            return true
        }
    }
    return false
}

ca_RemoveDuplicates(arr) {
    known := Map()
    for e in arr {
        if (!known.has(e)) {
            known[e] := True
        }
    }

    res := []
    for e in arr {
        if (known.has(e)) {
            res.push(e)
            known.delete(e)
        }
    }
    return res
}

ca_RemoveEmpty(arr) {
    res := []
    for e in arr {
        if (e != "") {
            res.push(e)
        }
    }
    return res
}