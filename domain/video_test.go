package domain_test

import (
	"fmt"
	"math/rand"
	"testing"
	"time"

	"github.com/MatheusAbdias/encoder/domain"
	uuid "github.com/satori/go.uuid"
	"github.com/stretchr/testify/require"
)

func TestVideoValidators(t *testing.T) {
	testCases := []struct {
		Name        string
		Video       *domain.Video
		ExpectedErr bool
	}{
		{
			"Creating Valid Video",
			&domain.Video{uuid.NewV4().String(), uuid.NewV4().String(), "path", time.Now()},
			false,
		},
		{
			"Invalid uuid for video",
			&domain.Video{fmt.Sprintf("%d", rand.Int()), uuid.NewV4().String(), "path", time.Now()},
			true,
		},
		{
			"Invalid video empty path",
			&domain.Video{uuid.NewV4().String(), uuid.NewV4().String(), "", time.Now()},
			true,
		},
	}

	for _, testCase := range testCases {

		err := testCase.Video.Validate()

		if testCase.ExpectedErr {
			require.Error(t, err)
		} else {
			require.NoError(t, err)
		}
	}
}
