// Chargement fichiers html pour compléter contenu de index.html
$(document).ready(function () {
  $('#introcontents').load("resources/html/intro.html");
  $('#courscontents').load("resources/html/bcours.html");
  $('#pgmcontents').load("resources/html/pgms.html");
  $('#select_pgm').load("resources/html/pgmslst.html");
  $('#infocontents').load("resources/html/info.html");
  $('#select_nc').load("resources/html/lnc.html");
});

// Déclaration variables
var nc = document.getElementById("select_nc");
var pgm = document.getElementById("select_pgm");
var tgraph = document.getElementById("target_graph");
var gen_Pdf = document.getElementById("gen_pdf");
var checkb = document.getElementById("checkbox");
var checktxt = document.getElementById("checktxt");
var groupcheck = document.getElementById("groupcheck");
var text = document.getElementById("texte");
var graphHelp = document.getElementById("graphHelp");

// Initialisation variables
var initial_text = text.innerHTML;
var checked = false;

// Fonctions permettant d'afficher et de cacer des composants de l'écran
function cacherInfo() {
  text.style.visibility = 'hidden';
}

function afficherInfo() {
  text.style.visibility = 'visible';
}

function cacherBoutonPDFGraphe() {
  graphHelp.style.visibility = 'hidden';
  gen_Pdf.style.visibility = 'hidden';
  tgraph.style.visibility = 'hidden';
}

function afficherBoutonPDFGraphe() {
  graphHelp.style.visibility = 'visible';
  gen_Pdf.style.visibility = 'visible';
  tgraph.style.visibility = 'visible';
}

function cacherOptionCheminement() {
  checktxt.style.visibility = 'hidden';
  checkb.style.visibility = 'hidden';
  groupcheck.style.visibility = 'hidden';
}

function afficherOptionCheminement() {
  checktxt.style.visibility = 'visible';
  checkb.style.visibility = 'visible';
  groupcheck.style.visibility = 'visible';
}

function cacherTout() {
  cacherInfo();
  cacherBoutonPDFGraphe();
  cacherOptionCheminement();
}

function afficherTout() {
  afficherInfo();
  afficherBoutonPDFGraphe();
  afficherOptionCheminement();
}

// Au chargement, bouton genPdf, parties graphe, checkbox et texte cachées
function reset() {
  cacherTout();

  pgm.value = "aucun";
  nc.value = "aucun";
  checkb.checked = "";
  $('body').removeClass('initial-hide');
  text.innerHTML = "";
}

// Appel à la génération du graphe
function generer_graphe() {
  var ncv = nc.value;
  var pgmv = pgm.value;

  if (ncv == "aucun" && pgm.value == "aucun") {
    cacherTout();
  } else if (nc.value != "aucun") {
    cacherOptionCheminement();
    afficherBoutonPDFGraphe();
    afficherInfo();
    genGraph(true);
  } else {
    afficherTout();
    genGraph(false);
  }
}

// Réinitialiser liste cours
function resetCours() {
  nc.selectedIndex = 0;
  generer_graphe();
}

// Réinitialiser liste programmes
function resetPgm() {
  pgm.selectedIndex = 0;
  generer_graphe();
}

// Valeur de checkbox change
checkb.addEventListener("click", function (event) {
  checked = !checked;
  genGraph(false);
});


// Variable globale partagée entre genGraph et genPDF
var elt = null;

// Fonction de génération de graphe de dépendances
function genGraph(dep_cours) {
  // On récupère l'objet où se situera le graphe généré
  var elem = tgraph;
  var res = null;
  var err = "";

  // Appel des fonctions importées d'Ocaml pour générer :
  // - le graphe de dépendances d'un cours (genDep);
  // - le graphe de dépendances d'un programme (genPgmDep);
  // - le graphe de dépendances d'un programme avec cheminement (genPgmDep).
  // Chaque retourne une paire, sous forme d'un tableau à 2 éléments, contenant
  // respectivement le graphe généré, ainsi qu'un message d'erreur éventuel: 
  // - si le message d'erreurs est différent de "", il y a donc erreur à 
  //   afficher, mais de graphe à afficher;
  // - sinon, si le graphe généré est "vide", on affiche que le cours ou le
  //   programme n'admet de graphe de dépendances;
  // - sinon, on affiche le graphe.
  if (dep_cours) {
    res = genDep(pgm.value, nc.value);
    graphe = res[0];
    err = res[1];
  }
  else {
    if (!checked) {
      res = genPgmDep(pgm.value);
      graphe = res[0];
      err = res[1];
    }
    else {
      res = genPgmDep2(pgm.value);
      graphe = res[0];
      err = res[1];
    }
  }

  // Afficher message si graphe vide, i.e. cours ne fait partie du pgm, ou
  // message d'erreur différent de chaine vide
  if (graphe == "vide" || err != "") {
    cacherBoutonPDFGraphe();
    cacherOptionCheminement();
    if (err != "") {
      text.innerHTML = "<font color=\"red\">" + err + "</font>";
      if (checked) {
        checked = false;
        checkb.checked = "";
      }
    }
    // le graphe généré est vide
    else if (dep_cours) {
      text.innerHTML =
        "<font color=\"red\">Cours ne fait partie du " + (pgm.value) + "</font>";
    }
    else {
      text.innerHTML =
        "<font color=\"red\">Pas de dépendances de cours dans " +
        (pgm.value) + "</font>";
    }
    // Graphe non vide et pas d'erreurs
  } else {
    if (dep_cours) {
      if (pgm.value == "aucun") {
        text.innerHTML = initial_text +
          "<b> du cours " + (nc.value).toUpperCase() + "</b>";
      }
      else {
        text.innerHTML = initial_text +
          "<b> du cours " + (nc.value).toUpperCase() +
          ", restreint au " +
          (pgm.value) + "</b>";
      }
    }
    else {
      afficherOptionCheminement();
      text.innerHTML = initial_text +
        "<b> des cours du " + (pgm.value) + "</b>";
    }

    // Création d'un objet de type Viz qui comprendra le graphe de dépendance
    var viz = new Viz();

    viz.renderSVGElement(graphe).then(function (element) {
      // Utilisée dans genPDF
      elt = element.cloneNode(true);

      // Permet de supprimer les anciens graphes affichés
      while (elem.firstChild) {
        elem.removeChild(elem.lastChild);
      };

      // Ajoute le nouveau graphe à target_graph
      elem.appendChild(element);
      element.setAttribute('id', 'svgraph');
      element.setAttribute('style', 'width: 100%;');

      // tgraph.style.height = element.style.height;

      var panZoomGraph = svgPanZoom('#svgraph', {
        zoomEnabled: false,
        dblClickZoomEnabled: false,
        controlIconsEnabled: false,
        fit: true,
        center: false,
        panEnabled: false,
        preventMouseEventsDefault: false
      });

      window.onresize = function () {
        panZoomGraph.resize();
        panZoomGraph.fit();
        panZoomGraph.center();
        panZoomGraph.pan({ x: 0, y: 0 });
      };

    }).catch(error => {
      viz = new Viz();
      console.error(error);
    });
  }
}

// Fonction de génération de graphe de dépendances en PDF
function genPDF() {

  const width = elt.width.baseVal.valueInSpecifiedUnits;
  const height = elt.height.baseVal.valueInSpecifiedUnits;

  const pdf = new jsPDF(width > height ? "l" : "p", 'pt', [width, height]);

  svg2pdf(elt, pdf, {
    xOffset: 0,
    yOffset: 0,
    scale: 1,
    removeInvalid: true
  });

  pdf.save('graphe_'.concat(nc.value).concat('_').concat(pgm.value).concat('.pdf'));

}

