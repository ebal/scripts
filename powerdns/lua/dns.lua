domainame = "test.example.org"
response  = "127.0.0.8"

function nxdomain(dq)
    if dq.qname:equal(domainame) then
        dq.rcode=0 -- make it a normal answer
        dq:addAnswer(pdns.A, response)
        dq.variable = true -- disable packet cache
        return true
    end
    return false
end
