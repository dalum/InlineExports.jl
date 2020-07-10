module NoExport

import Base: @__doc__

export @export

quote
    """
        @export

    No-op.  Used to disable inline exports.
    """
    macro $(Symbol("export"))(expr::Expr)
        return esc(expr)
    end
end |> eval

end # module
