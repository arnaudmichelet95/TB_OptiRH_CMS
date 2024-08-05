import plotly.graph_objects as go

# Exemple de données de perte d'entraînement et de validation
training_loss = [0.906500, 0.369100, 0.935300, 0.505100, 0.647000, 0.765700, 0.528900, 0.445200, 0.661700, 0.528700,
                 0.367400, 0.647000, 0.607900, 0.378200, 0.452300, 0.378400, 0.451800, 0.339300, 0.219300, 0.186900,
                 0.114400, 0.362700]
validation_loss = [0.717886, 0.693635, 0.679141, 0.671779, 0.674588, 0.669460, 0.666390, 0.663219, 0.658017, 0.686162,
                   0.691665, 0.683496, 0.688376, 0.719562, 0.731670, 0.727916, 0.736316, 0.731297, 0.802881, 0.804491,
                   0.808159, 0.804350]

steps = list(range(100, 2300, 100))

# Créer le graphique avec Plotly
fig = go.Figure()

# Ajouter les traces pour les pertes d'entraînement et de validation
fig.add_trace(go.Scatter(x=steps, y=training_loss, mode='lines+markers', name='Training Loss'))
fig.add_trace(go.Scatter(x=steps, y=validation_loss, mode='lines+markers', name='Validation Loss'))

# Configurer les axes et le titre
fig.update_layout(
    title='Training and Validation Loss Over Steps',
    xaxis_title='Steps',
    yaxis_title='Loss',
    legend_title='Loss Type'
)

# Afficher le graphique
fig.show()
