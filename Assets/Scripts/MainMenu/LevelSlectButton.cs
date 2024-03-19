using UnityEngine;
using UnityEngine.SceneManagement;

public class LevelSelectButton : MonoBehaviour
{
    [SerializeField] private int level;
    // Start is called before the first frame update
    void Start()
    {

    }

    public void LoadScene()
    {
        SceneManager.LoadScene("Level " + level.ToString());
    }
}
