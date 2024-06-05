# Caso 5: Secuestro en la ciudad

El mundo se sume en el caos cuando se revela que la hija del presidente de Estados Unidos ha sido secuestrada por una despiadada organización criminal. La situación es crítica, y cada momento cuenta. Como nuestro agente principal, te embarcas en una misión urgente para identificar y desmantelar a los responsables antes de que sea demasiado tarde.

## Objetivo: Identificar a los principales sospechosos del secuestro.

El destino de la hija del presidente está en juego, y necesitamos información que nos permita localizar a los secuestradores. 

Utilizando la base de datos, tu tarea es asignar una puntuación a cada individuo sospechoso, ordenándolos según su probabilidad de ser el culpable de este crimen (clasificado como "Kidnapping in the city" en la base de datos). 

La puntuación se calculará en base a los siguientes criterios:
- Conoce a la víctima.
- Frecuenta el lugar donde ocurrió el crimen.
- Tiene antecedentes criminales.
- Posee una personalidad agresiva.
- Mide al menos 170 cm.
- Es propietario de al menos uno de los objetos encontrados en la escena del crimen.
- Pertenece a una organización criminal activa.

Cada condición coincidente sumará +1 a la puntuación total del individuo (dando un máximo de 7). Al identificar a los sospechosos con la puntuación más alta, no solo estaremos más cerca de obtener la información necesaria para rescatar a la hija del presidente, sino que también podríamos descubrir al líder de la organización criminal responsable.

El listado a generar deberá contener las 10 personas con la puntuación más alta y, por tanto, con mayor probabilidad de estar relacionados con el incidente. Para cada uno de ellos deberás incluir el NIF, el nombre, la puntuación obtenida y, en caso de haberla, el nombre de la organización criminal a la que pertenecen.