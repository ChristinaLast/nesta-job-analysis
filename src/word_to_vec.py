import csv
import gc
import time
from typing import Any, Optional, Sequence, Tuple

import gensim
import pandas as pd
from gensim.models import KeyedVectors
from sklearn.decomposition import PCA
from sklearn.manifold import TSNE

import bootstrap  # noqa

from .preprocessing import Preprocessing

print("start", time.strftime("%H:%M:%S"))


class OccupationWord2Vec:
    def __init__(self, occupation_description: Optional[str], path_to_word_2_vec_model: str):
        self.occupation_description = occupation_description
        self.path_to_word_2_vec_model = path_to_word_2_vec_model

    def execute(self) -> None:
        fitted_word_2_vec_model = self.fit_word_2_vec_model()
        fitted_word_2_vec_model.intersect_word2vec_format(
            self.path_to_word_2_vec_model, lockf=1.0, binary=True
        )
        count = 2

        for i in range(count):
            fitted_word_2_vec_model.train(
                self.occupation_description,
                total_examples=fitted_word_2_vec_model.corpus_count,
                epochs=fitted_word_2_vec_model.iter,
            )

        (
            trained_word_2_vec_items,
            trained_word_2_vec_vocab,
        ) = self.return_trained_items_vocab(fitted_word_2_vec_model)

        trained_tsne = self.fit_tsne_model(trained_word_2_vec_vocab)

        with open("data/word_2_vec_trained_occupations.csv", "w") as f:
            writer = csv.writer(f)
            for i in range(trained_tsne.shape[0]):
                self.write_trained_tsne_to_df(writer, i, trained_tsne, trained_word_2_vec_items)

    def fit_word_2_vec_model(self) -> gensim.models.Word2Vec:
        fitted_word_2_vec_model = gensim.models.Word2Vec(
            self.occupation_description, size=300, window=2, min_count=1, workers=1
        )
        return fitted_word_2_vec_model

    def return_trained_items_vocab(
        self, trained_word_2_vec_model: gensim.models.Word2Vec.intersect_word2vec_format
    ) -> Tuple[Any, Any]:
        trained_word_2_vec_items = trained_word_2_vec_model.wv.vocab.items()
        trained_word_2_vec_vocab = trained_word_2_vec_model[trained_word_2_vec_model.wv.vocab]

        return trained_word_2_vec_items, trained_word_2_vec_vocab

    def fit_tsne_model(self, trained_word_2_vec_vocab) -> TSNE.fit_transform:
        tsne = TSNE(n_components=3)
        return tsne.fit_transform(trained_word_2_vec_vocab)

    def write_trained_tsne_to_df(self, writer, i, trained_tsne, trained_word_2_vec_items) -> None:
        trained_tsne_list = list(trained_tsne[i, :])
        trained_tsne_list.append(list(trained_word_2_vec_items)[i][0])
        writer.writerow(trained_tsne_list)
