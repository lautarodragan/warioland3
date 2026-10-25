import os
import sys
from pathlib import Path

import pytest
from PIL import Image, ImageChops

sys.path.insert(0, str(Path(__file__).resolve().parent))

from game import ROM, SYM, Game  # noqa: E402

TESTS = Path(__file__).resolve().parent
GOLDENS = TESTS / "goldens"
OUTPUT = TESTS / "output"


def pytest_addoption(parser):
    parser.addoption(
        "--update-goldens",
        action="store_true",
        default=bool(os.environ.get("UPDATE_GOLDENS")),
        help="Overwrite golden screenshots with the current output.",
    )


@pytest.fixture
def game():
    if not ROM.exists() or not SYM.exists():
        pytest.skip("build the ROM with `make` first")
    g = Game()
    yield g
    g.close()


@pytest.fixture
def golden(request):
    """Compare a screenshot against tests/goldens/<name>.png.

    Every screenshot is also written to tests/output/ so it can be inspected
    (and, if correct, promoted with --update-goldens).
    """
    update = request.config.getoption("--update-goldens")

    def check(name, image):
        OUTPUT.mkdir(exist_ok=True)
        actual_path = OUTPUT / f"{name}.png"
        image.save(actual_path)

        golden_path = GOLDENS / f"{name}.png"
        if update:
            GOLDENS.mkdir(exist_ok=True)
            image.save(golden_path)
            return
        if not golden_path.exists():
            pytest.fail(
                f"no golden for {name!r}; inspect {actual_path} and rerun "
                "with --update-goldens to accept it"
            )

        expected = Image.open(golden_path).convert("RGB")
        diff = ImageChops.difference(image, expected)
        bbox = diff.getbbox()
        if bbox is not None:
            diff_path = OUTPUT / f"{name}.diff.png"
            diff.point(lambda v: 255 if v else 0).save(diff_path)
            pytest.fail(
                f"{name!r} differs from golden in region {bbox}; "
                f"see {actual_path} and {diff_path}"
            )

    return check
