using ControlSystemsBase
using LinearAlgebra

function delay_lqr(sys::StateSpace, h::Float64; Q=I, R=I)
    sysd_delay = c2da(sys, h)
    lqr(sysd_delay, Q, R)
end

# Pole placement only works with single input single output (SISO) systems. i.e., 
# sys.B & sys.D can only have 1 column and sys.C & sys.D can only have 1 row
function pole_place(sys::StateSpace, h::Float64; p=0.9)
    sysd_delay = c2da(sys, h)
    place(sysd_delay, vcat([0], fill(p, size(sys.A)[1])))
end

function c2da(sys::StateSpace, h::Float64)
    augment(c2d(sys, h))
end

function augment(sysd)
    p = size(sysd.A, 1)
    q = size(sysd.B, 2)
    r = size(sysd.C, 1)
    A = [sysd.A sysd.B; zeros(q, p+q)]
    B = [zeros(p, q); I]
    C = [sysd.C zeros(r, q)]
    D = sysd.D
    ss(A, B, C, D, sysd.Ts)
end
