events = new EventBus()
skill_tree = new SkillTree()

tween_mgr = new TweenManager()
shader_mgr = new ShaderManager()

application_surface_draw_enable(false)
show_debug_overlay(true)

pessoas = 1000

odio = 0
celebridades = 0
vies = 0
banal = 0
economia = 0
polemicos = 0

violencia = 10
confianca = 60
seriedade = 80

corrupcao = (vies + (economia + polemicos) / 5)

fator =
    sqrt(
        (power(abs(1 + banal), 0.2) * ((power(celebridades, 0.4) * 0.2) + (power(odio, 0.6) * 0.2)))
        + ((celebridades * 0.3) / (celebridades + 0.5))
        - (economia * 0.3)
        + random_range(0.1, 0.3)
        + (((polemicos - max(0, vies * 0.1)) * power(celebridades, 0.3)) * 0.3)
    )

fator = max(0.05, fator)

/*
show_message(
    $"Pessoas: {pessoas}; Fator: {fator}; Total: {floor(pessoas + pessoas * fator)}\n" +
    $"Violência: {violencia + (odio * 5) + (corrupcao * 5)}\n" +
    $"Confiança: {confianca + (vies * 5) + (corrupcao * 2.5)}\n" +
    $"Seriedade: {seriedade - max(0, banal * 15)}"
)
*/