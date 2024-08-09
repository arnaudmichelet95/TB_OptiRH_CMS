import plotly.graph_objects as go

# Nouvelles données de perte d'entraînement et de validation
training_loss = [
    2.044800, 1.532700, 1.465300, 1.420700, 1.411900, 1.464300, 1.497700, 1.395100, 1.406900, 1.390100,
    1.402100, 1.468200, 1.399500, 1.372100, 1.448500, 1.385300, 1.467800, 1.437700, 1.329100, 1.447100,
    1.400900, 1.333200, 1.443800, 1.418000, 1.431900, 1.420900, 1.439000, 1.352500, 1.289100, 1.437100,
    1.451400, 1.362400, 1.377400, 1.340000, 1.417600, 1.414200, 1.449000, 1.350300, 1.341100, 1.369900,
    1.389100, 1.386900, 1.396000, 1.506700, 1.403900, 1.334000, 1.410600, 1.333900, 1.430700, 1.351100
]
validation_loss = [
    1.551314, 1.481913, 1.446972, 1.434965, 1.425641, 1.419109, 1.413700, 1.409721, 1.405307, 1.402487,
    1.400285, 1.396560, 1.393408, 1.389809, 1.387074, 1.383816, 1.380876, 1.377907, 1.376761, 1.375494,
    1.373625, 1.372298, 1.371441, 1.368727, 1.367067, 1.365667, 1.364928, 1.363848, 1.362468, 1.360726,
    1.359565, 1.359008, 1.357444, 1.356401, 1.355679, 1.355089, 1.354288, 1.353902, 1.353274, 1.352970,
    1.352061, 1.351435, 1.351067, 1.350482, 1.350239, 1.349670, 1.349310, 1.349100, 1.348882, 1.348820
]

steps = list(range(10, 510, 10))

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
