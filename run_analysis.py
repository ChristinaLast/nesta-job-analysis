from typing import Any, Optional, Sequence, Tuple

import click

import bootstrap  # noqa
from src.lda import OccupationLDA
from src.postprocessing import Postprocessing
from src.preprocessing import Preprocessing
from src.word_to_vec import OccupationWord2Vec


def run_preprocess(path_to_occupation_csv: str):
    pre_processing = Preprocessing(path_to_occupation_csv)
    pre_processing.execute()


@click.command("preprocess", help="Preprocess raw job data")
@click.argument("data_path", type=click.Path(exists=True))
def preprocess(data_path: str):
    run_preprocess(path_to_occupation_csv=data_path)


def run_word_2_vec(path_to_word_2_vec_model: str, path_to_occupation_csv: Optional[str]):
    pre_processing = Preprocessing(path_to_occupation_csv)
    processed_occupation_description = pre_processing.execute()

    occupation_word_2_vec = OccupationWord2Vec(
        processed_occupation_description,
        path_to_word_2_vec_model,
    )
    occupation_word_2_vec.execute()


@click.command("word_2_vec", help="Retrain google news word vectors with job descriptions")
@click.argument("model_path")
@click.argument("data_path", type=click.Path(exists=True))
def word_2_vec(model_path: str, data_path: Optional[str]):
    run_word_2_vec(path_to_word_2_vec_model=model_path, path_to_occupation_csv=data_path)


def run_lda(path_to_processed_occupation_csv: Optional[str], stop_word_language: Optional[str]):
    if path_to_processed_occupation_csv:
        occupation_lda = OccupationLDA(get_stop_words(stop_word_language))
        occupation_lda.execute(path_to_processed_occupation_csv)
    else:
        pre_processing = Preprocessing("data/occupations_en.csv")
        processed_occupation_description = pre_processing.execute()
        occupation_lda = OccupationLDA(get_stop_words(stop_word_language))
        occupation_lda.execute("data/processed_only_job_title_occupation.csv")


@click.command("lda", help="Analyse job titles and descriptions using LDA ")
@click.argument("data_path", type=click.Path(exists=True))
def lda(data_path: str):
    run_lda(path_to_processed_occupation_csv=data_path, stop_word_language="en")


def postprocess(path_to_lda_occupation_csv: Optional[str]):
    if path_to_lda_occupation_csv:
        post_processing = Postprocessing(path_to_lda_occupation_csv)
        post_processing.execute()
    else:
        pre_processing = Preprocessing("data/occupations_en.csv")
        processed_occupation_description = pre_processing.execute()
        occupation_lda = OccupationLDA(get_stop_words(stop_word_language))
        occupation_lda.execute("data/processed_only_job_title_occupation.csv")
        post_processing = Postprocessing("data/occupations_lda_10_topics.csv")
        post_processing.execute()


@click.command("postprocess", help="Reformat output of LDA analysis")
@click.argument("data_path", type=click.Path(exists=True))
def postprocess(data_path: str):
    run_postprocess(path_to_lda_occupation_csv=data_path)


@click.group("nesta-job-analysis", help="Run full analysis pipeline")
@click.pass_context
def cli(ctx):
    ...


cli.add_command(preprocess)
cli.add_command(word_2_vec)
cli.add_command(lda)
cli.add_command(postprocess)


if __name__ == "__main__":
    cli()
